require 'rails_helper'

RSpec.describe JobOrders::JobOrdersReactor do # rubocop:disable Metrics/BlockLength
  it_behaves_like "a replayable message consumer"

  let(:instance) { described_class.new(message_service:) }
  let(:message_service) { MessageService.new }

  describe "#add_job_order" do
    subject do
      instance.add_job_order(job_order_id:, job_id:, trace_id:)
    end

    let(:job_order_id) { SecureRandom.uuid }
    let(:job_id) { SecureRandom.uuid }
    let(:trace_id) { SecureRandom.uuid }

    it "fires off a job order order count added event" do
      expect(message_service)
        .to receive(:create!)
        .with(
          schema: Commands::AddJobOrder::V1,
          job_order_id:,
          trace_id:,
          data: {
            job_id:
          }
        )

      subject
    end
  end

  describe "#add_order_count" do
    subject do
      instance.add_order_count(job_order_id:, order_count:, trace_id:)
    end

    let(:job_order_id) { 10 }
    let(:order_count) { 10 }
    let(:trace_id) { SecureRandom.uuid }

    it "fires off a job order order count added event" do
      expect(message_service)
        .to receive(:create!)
        .with(
          schema: Events::JobOrderOrderCountAdded::V1,
          job_order_id:,
          trace_id:,
          data: {
            order_count:
          }
        )

      subject
    end
  end

  describe "#activate_job_order" do
    subject do
      instance.activate_job_order(job_order_id:, trace_id:)
    end

    let(:job_order_id) { 10 }
    let(:trace_id) { SecureRandom.uuid }

    it "fires off a job order order activated event" do
      expect(message_service)
        .to receive(:create!)
        .with(
          schema: Commands::ActivateJobOrder::V1,
          job_order_id:,
          trace_id:,
          data: Messages::Nothing
        )

      subject
    end
  end

  describe "#close_job_order_not_filled" do
    subject do
      instance.close_job_order_not_filled(job_order_id:, trace_id:)
    end

    let(:job_order_id) { 10 }
    let(:trace_id) { SecureRandom.uuid }

    it "fires off a job order order activated event" do
      expect(message_service)
        .to receive(:create!)
        .with(
          schema: Events::JobOrderNotFilled::V1,
          job_order_id:,
          trace_id:,
          data: Messages::Nothing
        )

      subject
    end
  end

  describe "#update_status" do
    subject do
      instance.update_status(status:, job_order_id:, seeker_id:, trace_id:)
    end
    let(:candidate) { create(:job_orders__candidate) }
    let(:seeker_id) { candidate.seeker_id }
    let(:job_order_id) { candidate.job_order_id }
    let(:trace_id) { SecureRandom.uuid }

    context "added" do
      let(:status) { "added" }

      it "emits a added event" do
        expect(message_service)
          .to receive(:create!)
          .with(
            schema: Events::JobOrderCandidateAdded::V1,
            job_order_id:,
            trace_id:,
            data: {
              seeker_id:
            }
          ).and_call_original

        subject
      end
    end

    context "recommended" do
      let(:status) { "recommended" }

      it "emits a recommended event" do
        expect(message_service)
          .to receive(:create!)
          .with(
            schema: Events::JobOrderCandidateRecommended::V1,
            job_order_id:,
            trace_id:,
            data: {
              seeker_id:
            }
          ).and_call_original

        subject
      end
    end

    context "hired" do
      let(:status) { "hired" }

      it "emits a hired event" do
        expect(message_service)
          .to receive(:create!)
          .with(
            schema: Events::JobOrderCandidateHired::V1,
            job_order_id:,
            trace_id:,
            data: {
              seeker_id:
            }
          ).and_call_original

        subject
      end
    end

    context "rescinded" do
      let(:status) { "rescinded" }

      it "emits a rescinded event" do
        expect(message_service)
          .to receive(:create!)
          .with(
            schema: Events::JobOrderCandidateRescinded::V1,
            job_order_id:,
            trace_id:,
            data: {
              seeker_id:
            }
          ).and_call_original

        subject
      end
    end
  end

  describe "#handle_message" do # rubocop:disable Metrics/BlockLength
    subject { instance.handle_message(message) }

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

    context "when the message is applicant status updated" do
      let(:message) do
        build(
          :message,
          schema: Events::ApplicantStatusUpdated::V6,
          occurred_at: Time.zone.local(2019, 1, 1),
          data: {
            applicant_first_name: "first_name",
            applicant_last_name: "last_name",
            applicant_email: "email",
            applicant_phone_number: "phone_number",
            seeker_id:,
            user_id: "user_id",
            job_id:,
            employer_name: "employer_name",
            employment_title: "employment_title",
            status:,
            reasons: []
          },
          metadata: {}
        )
      end

      let(:seeker_id) { SecureRandom.uuid }
      let(:job_id) { SecureRandom.uuid }

      context "when status is not new" do
        let(:status) { ApplicantStatus::StatusTypes::INTERVIEWING }

        it "does nothing" do
          expect(message_service)
            .not_to receive(:create_once_for_trace!)

          subject
        end
      end

      context "when status is new" do
        before do
          messages.each do |message|
            Event.from_message!(message)
          end
        end

        let(:status) { ApplicantStatus::StatusTypes::NEW }

        context "when there is not a job order for the job_id" do
          let(:messages) { [] }

          it "does nothing" do
            expect(message_service)
              .not_to receive(:create_once_for_trace!)

            subject
          end
        end

        context "when there are job orders for the job_id" do
          let(:messages) { [job_order1, job_order1_closed, job_order2] }

          let(:job_order1) do
            build(
              :message,
              schema: Events::JobOrderAdded::V1,
              occurred_at: Time.zone.local(2019, 1, 1),
              data: {
                job_id:
              }
            )
          end
          let(:job_order1_closed) do
            build(
              :message,
              aggregate: job_order1.aggregate,
              schema: Events::JobOrderNotFilled::V1,
              occurred_at: Time.zone.local(2019, 6, 1),
              data: Messages::Nothing
            )
          end
          let(:job_order2) do
            build(
              :message,
              schema: Events::JobOrderAdded::V1,
              occurred_at: Time.zone.local(2020, 1, 1),
              data: {
                job_id:
              }
            )
          end

          it "emits the relevants messages" do
            expect(message_service)
              .to receive(:create_once_for_trace!)
              .with(
                schema: Events::JobOrderCandidateAdded::V1,
                trace_id: message.trace_id,
                aggregate: job_order2.aggregate,
                data: {
                  seeker_id: message.data.seeker_id
                }
              )
              .and_call_original

            expect(message_service)
              .to receive(:create_once_for_trace!)
              .with(
                schema: Events::JobOrderCandidateApplied::V1,
                trace_id: message.trace_id,
                aggregate: job_order2.aggregate,
                data: {
                  seeker_id: message.data.seeker_id,
                  applied_at: message.occurred_at
                }
              )
              .and_call_original

            subject
          end
        end
      end
    end

    context "when the message is add job order" do
      before do
        messages.each do |message|
          Event.from_message!(message)
        end
      end

      let(:message) do
        build(
          :message,
          schema: Commands::AddJobOrder::V1,
          aggregate:,
          data: {
            job_id:
          }
        )
      end
      let(:job_id) { SecureRandom.uuid }
      let(:aggregate) { Aggregates::JobOrder.new(job_order_id: SecureRandom.uuid) }

      context "when there is an active job order" do
        let(:messages) do
          [
            build(
              :message,
              schema: Events::JobOrderAdded::V1,
              aggregate:,
              occurred_at: Time.zone.local(2019, 1, 1),
              data: {
                job_id:
              }
            )
          ]
        end

        it "emits a job order creation failed event" do
          expect(message_service)
            .to receive(:create_once_for_trace!)
            .with(
              schema: Events::JobOrderCreationFailed::V1,
              trace_id: message.trace_id,
              aggregate: message.aggregate,
              data: {
                job_id: message.data.job_id,
                reason: "There is an existing active job order present"
              }
            )
            .and_call_original

          subject
        end
      end

      context "when there is not an active job order" do
        let(:messages) { [] }

        it "emits a job order added event" do
          expect(message_service)
            .to receive(:create_once_for_trace!)
            .with(
              schema: Events::JobOrderAdded::V1,
              trace_id: message.trace_id,
              aggregate: message.aggregate,
              data: {
                job_id: message.data.job_id
              }
            )
            .and_call_original

          subject
        end
      end
    end

    context "when the message is activate job order" do
      before do
        messages.each do |message|
          Event.from_message!(message)
        end
      end

      let(:message) do
        build(
          :message,
          schema: Commands::ActivateJobOrder::V1,
          aggregate:,
          data: Messages::Nothing
        )
      end
      let(:job_id) { SecureRandom.uuid }
      let(:aggregate) { Aggregates::JobOrder.new(job_order_id: SecureRandom.uuid) }

      context "when there is an active job order" do
        let(:messages) do
          [
            build(
              :message,
              schema: Events::JobOrderAdded::V1,
              aggregate:,
              occurred_at: Time.zone.local(2019, 1, 1),
              data: {
                job_id:
              }
            )
          ]
        end

        it "emits a job order activation failed event" do
          expect(message_service)
            .to receive(:create_once_for_trace!)
            .with(
              schema: Events::JobOrderActivationFailed::V1,
              trace_id: message.trace_id,
              aggregate: message.aggregate,
              data: {
                reason: "There is an existing active job order present"
              }
            )
            .and_call_original

          subject
        end
      end

      context "when there is not a job order" do
        let(:messages) do
          []
        end

        it "reports to sentry a job order was not found" do
          expect(Sentry)
            .to receive(:capture_exception)
            .with(
              MessageConsumer::FailedToHandleMessage.new("Job Order not found", message)
            )
            .and_call_original

          subject
        end
      end

      context "when there is not an active job order" do
        let(:messages) do
          [
            build(
              :message,
              schema: Events::JobOrderAdded::V1,
              aggregate:,
              occurred_at: Time.zone.local(2019, 1, 1),
              data: {
                job_id:
              }
            ),
            build(
              :message,
              schema: Events::JobOrderNotFilled::V1,
              aggregate:,
              occurred_at: Time.zone.local(2019, 1, 1),
              data: Messages::Nothing
            )
          ]
        end

        it "emits a job order activated event" do
          expect(message_service)
            .to receive(:create_once_for_trace!)
            .with(
              schema: Events::JobOrderActivated::V1,
              trace_id: message.trace_id,
              aggregate: message.aggregate,
              data: Messages::Nothing
            )
            .and_call_original

          subject
        end
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
              JobOrders::Projectors::JobOrderExistingStatus::Projection.new(status: JobOrders::ActivatedStatus::OPEN)
            end
            let(:new_status) do
              JobOrders::Projectors::JobOrderStatus::Projection.new(
                order_count: 1,
                candidates: {},
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
                JobOrders::Projectors::JobOrderExistingStatus::Projection.new(status: JobOrders::StalledStatus::WAITING_ON_EMPLOYER)
              end
              let(:new_status) do
                JobOrders::Projectors::JobOrderStatus::Projection.new(
                  order_count: 2,
                  candidates: {},
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
                JobOrders::Projectors::JobOrderExistingStatus::Projection.new(status: JobOrders::ActivatedStatus::OPEN)
              end
              let(:new_status) do
                JobOrders::Projectors::JobOrderStatus::Projection.new(
                  order_count: 2,
                  candidates: { one: :recommended, two: :recommended },
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
                      status: JobOrders::StalledStatus::WAITING_ON_EMPLOYER
                    }
                  )

                subject
              end
            end

            context "when the new status should be filled" do
              let(:existing_status) do
                JobOrders::Projectors::JobOrderExistingStatus::Projection.new(status: JobOrders::ActivatedStatus::OPEN)
              end
              let(:new_status) do
                JobOrders::Projectors::JobOrderStatus::Projection.new(
                  order_count: 1,
                  candidates: { one: :hired },
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
                JobOrders::Projectors::JobOrderExistingStatus::Projection.new(status: JobOrders::ActivatedStatus::OPEN)
              end
              let(:new_status) do
                JobOrders::Projectors::JobOrderStatus::Projection.new(
                  order_count: 1,
                  candidates: { one: :hired },
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
            schema: Events::JobOrderOrderCountAdded::V1,
            data: {
              order_count: 2
            }
          )
        end

        it_behaves_like "emits new status events if necessary"
      end
    end
  end
end
