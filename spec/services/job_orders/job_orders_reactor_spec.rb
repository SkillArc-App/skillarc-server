require 'rails_helper'

RSpec.describe JobOrders::JobOrdersReactor do
  it_behaves_like "a message consumer"

  describe "#handle_message" do
    subject { instance.handle_message(message) }

    let(:instance) { described_class.new(message_service:) }
    let(:message_service) { MessageService.new }

    context "when the message is job created" do
      let(:message) do
        build(
          :message,
          schema: Events::JobCreated::V3,
          data: {
            category: Job::Categories::MARKETPLACE,
            employment_title: "A title",
            employer_name: "An employer",
            employer_id: SecureRandom.uuid,
            benefits_description: "Bad benifits",
            responsibilities_description: nil,
            location: "Columbus Ohio",
            employment_type: Job::EmploymentTypes::FULLTIME,
            hide_job: false
          }
        )
      end

      it "emits a JobOrderAdded event" do
        expect(message_service)
          .to receive(:create_once_for_trace!)
          .with(
            schema: Events::JobOrderAdded::V1,
            job_order_id: be_a(String),
            trace_id: message.trace_id,
            data: {
              job_id: message.aggregate.id
            }
          )

        subject
      end
    end

    context "for events that might trigger new job order status" do
      shared_examples "emits new status events if necessary" do
        context "when possible to emit a new status" do
          before do
            expect(JobOrders::Projectors::JobOrderExistingStatus)
              .to receive(:project)
              .with(aggregate: message.aggregate)
              .and_return(existing_status)
            expect(JobOrders::Projectors::JobOrderStatus)
              .to receive(:project)
              .with(aggregate: message.aggregate)
              .and_return(new_status)
          end

          context "when the current status and new status are the same" do
            let(:existing_status) do
              JobOrders::Projectors::JobOrderExistingStatus::Projection.new(status: JobOrders::OpenStatus::OPEN)
            end
            let(:new_status) do
              JobOrders::Projectors::JobOrderStatus::Projection.new(
                hired_candidates: Set[],
                order_count: 1,
                candidates: Set[],
                recommended_candidates: Set[],
                rescinded_candidates: Set[],
                not_filled?: false
              )
            end

            it "does not emit a new message" do
              expect(message_service)
                .not_to receive(:create_once_for_trace!)

              subject
            end
          end

          context "when the current status and new status are the different" do
            context "when the new status should be activated" do
              let(:existing_status) do
                JobOrders::Projectors::JobOrderExistingStatus::Projection.new(status: JobOrders::IdleStatus::WAITING_ON_EMPLOYER)
              end
              let(:new_status) do
                JobOrders::Projectors::JobOrderStatus::Projection.new(
                  hired_candidates: Set[],
                  order_count: 2,
                  candidates: Set[],
                  recommended_candidates: Set[],
                  rescinded_candidates: Set[],
                  not_filled?: false
                )
              end

              it "emits an activated event" do
                expect(message_service)
                  .to receive(:create_once_for_trace!)
                  .with(
                    trace_id: message.trace_id,
                    aggregate: message.aggregate,
                    schema: Events::JobOrderActivated::V1,
                    data: Messages::Nothing
                  )

                subject
              end
            end

            context "when the new status should be stalled" do
              let(:existing_status) do
                JobOrders::Projectors::JobOrderExistingStatus::Projection.new(status: JobOrders::OpenStatus::OPEN)
              end
              let(:new_status) do
                JobOrders::Projectors::JobOrderStatus::Projection.new(
                  hired_candidates: Set[],
                  order_count: 2,
                  candidates: Set[],
                  recommended_candidates: Set[1, 2],
                  rescinded_candidates: Set[],
                  not_filled?: false
                )
              end

              it "emits an waiting on employer event" do
                expect(message_service)
                  .to receive(:create_once_for_trace!)
                  .with(
                    trace_id: message.trace_id,
                    aggregate: message.aggregate,
                    schema: Events::JobOrderStalled::V1,
                    data: {
                      status: JobOrders::IdleStatus::WAITING_ON_EMPLOYER
                    }
                  )

                subject
              end
            end

            context "when the new status should be filled" do
              let(:existing_status) do
                JobOrders::Projectors::JobOrderExistingStatus::Projection.new(status: JobOrders::OpenStatus::OPEN)
              end
              let(:new_status) do
                JobOrders::Projectors::JobOrderStatus::Projection.new(
                  hired_candidates: Set[1, 2],
                  order_count: 2,
                  candidates: Set[],
                  recommended_candidates: Set[],
                  rescinded_candidates: Set[],
                  not_filled?: false
                )
              end

              it "emits an filled event" do
                expect(message_service)
                  .to receive(:create_once_for_trace!)
                  .with(
                    trace_id: message.trace_id,
                    aggregate: message.aggregate,
                    schema: Events::JobOrderFilled::V1,
                    data: Messages::Nothing
                  )

                subject
              end
            end

            context "when the new status should be not filled" do
              let(:existing_status) do
                JobOrders::Projectors::JobOrderExistingStatus::Projection.new(status: JobOrders::OpenStatus::OPEN)
              end
              let(:new_status) do
                JobOrders::Projectors::JobOrderStatus::Projection.new(
                  hired_candidates: Set[1, 2],
                  order_count: 2,
                  candidates: Set[],
                  recommended_candidates: Set[],
                  rescinded_candidates: Set[],
                  not_filled?: true
                )
              end

              it "emits a not filled event" do
                expect(message_service)
                  .to receive(:create_once_for_trace!)
                  .with(
                    trace_id: message.trace_id,
                    aggregate: message.aggregate,
                    schema: Events::JobOrderNotFilled::V1,
                    data: Messages::Nothing
                  )

                subject
              end
            end
          end
        end
      end

      context "when the message is job order candidate added" do
        let(:message) do
          build(
            :message,
            schema: Events::JobOrderCandidateAdded::V1,
            data: {
              seeker_id: SecureRandom.uuid
            }
          )
        end

        it_behaves_like "emits new status events if necessary"
      end

      context "when the message is job order candidate recommended" do
        let(:message) do
          build(
            :message,
            schema: Events::JobOrderCandidateRecommended::V1,
            data: {
              seeker_id: SecureRandom.uuid
            }
          )
        end

        it_behaves_like "emits new status events if necessary"
      end

      context "when the message is job order candidate hired" do
        let(:message) do
          build(
            :message,
            schema: Events::JobOrderCandidateHired::V1,
            data: {
              seeker_id: SecureRandom.uuid
            }
          )
        end

        it_behaves_like "emits new status events if necessary"
      end

      context "when the message is job order candidate rescinded" do
        let(:message) do
          build(
            :message,
            schema: Events::JobOrderCandidateRescinded::V1,
            data: {
              seeker_id: SecureRandom.uuid
            }
          )
        end

        it_behaves_like "emits new status events if necessary"
      end

      context "when the message is job order added" do
        let(:message) do
          build(
            :message,
            schema: Events::JobOrderAdded::V1,
            data: {
              job_id: SecureRandom.uuid,
              order_count: 2
            }
          )
        end

        it_behaves_like "emits new status events if necessary"
      end
    end
  end
end
