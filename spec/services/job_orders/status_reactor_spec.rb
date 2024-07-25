require 'rails_helper'

RSpec.describe JobOrders::StatusReactor do
  it_behaves_like "a replayable message consumer"

  let(:instance) { described_class.new(message_service:) }
  let(:message_service) { MessageService.new }
  let(:trace_id) { SecureRandom.uuid }
  let(:job_order_id) { SecureRandom.uuid }
  let(:job_id) { SecureRandom.uuid }
  let(:person_id) { SecureRandom.uuid }
  let(:stream) { JobOrders::Streams::JobOrder.new(job_order_id:) }

  describe "#handle_message" do
    subject { instance.handle_message(message) }

    before do
      messages.each do |message|
        Event.from_message!(message)
      end
    end

    let(:messages) { [] }

    shared_examples "emits new status events if necessary" do
      context "when possible to emit a new status" do
        before do
          expect_any_instance_of(JobOrders::Projectors::JobOrderExistingStatus)
            .to receive(:project)
            .with(filtered_messages)
            .and_return(existing_status)
          expect_any_instance_of(JobOrders::Projectors::JobOrderStatus)
            .to receive(:project)
            .with(filtered_messages)
            .and_return(new_status)

          expect(MessageService)
            .to receive(:stream_events)
            .with(message.stream)
            .and_return(messages)
        end

        let(:message1) do
          build(
            :message,
            schema: JobOrders::Events::CandidateAdded::V3,
            data: {
              person_id: SecureRandom.uuid
            },
            metadata: {
              requestor_type: nil,
              requestor_id: nil,
              requestor_email: nil
            },
            occurred_at: message.occurred_at - 1.day
          )
        end
        let(:message2) do
          build(
            :message,
            schema: JobOrders::Events::CandidateAdded::V3,
            data: {
              person_id: SecureRandom.uuid
            },
            metadata: {
              requestor_type: nil,
              requestor_id: nil,
              requestor_email: nil
            },
            occurred_at: message.occurred_at + 1.day
          )
        end

        let(:messages) { [message1, message2] }
        let(:filtered_messages) { [message1] }

        context "when the current status and new status are the same" do
          let(:existing_status) do
            JobOrders::Projectors::JobOrderExistingStatus::Projection.new(status: JobOrders::OrderStatus::OPEN)
          end
          let(:new_status) do
            JobOrders::Projectors::JobOrderStatus::Projection.new(
              order_count: 1,
              criteria_met?: true,
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
          context "when the new status should be need critiera" do
            let(:existing_status) do
              JobOrders::Projectors::JobOrderExistingStatus::Projection.new(status: JobOrders::OrderStatus::WAITING_ON_EMPLOYER)
            end
            let(:new_status) do
              JobOrders::Projectors::JobOrderStatus::Projection.new(
                order_count: 2,
                criteria_met?: false,
                candidates: {},
                not_filled?: false
              )
            end

            it "emits an activated event" do
              expect(message_service)
                .to receive(:create_once_for_trace!)
                .with(
                  trace_id: message.trace_id,
                  stream: message.stream,
                  schema: JobOrders::Events::StatusUpdated::V1,
                  data: {
                    status: JobOrders::OrderStatus::NEEDS_CRITERIA
                  }
                )

              subject
            end
          end

          context "when the new status should be activated" do
            let(:existing_status) do
              JobOrders::Projectors::JobOrderExistingStatus::Projection.new(status: JobOrders::OrderStatus::WAITING_ON_EMPLOYER)
            end
            let(:new_status) do
              JobOrders::Projectors::JobOrderStatus::Projection.new(
                order_count: 2,
                criteria_met?: true,
                candidates: {},
                not_filled?: false
              )
            end

            it "emits an activated event" do
              expect(message_service)
                .to receive(:create_once_for_trace!)
                .with(
                  trace_id: message.trace_id,
                  stream: message.stream,
                  schema: JobOrders::Events::StatusUpdated::V1,
                  data: {
                    status: JobOrders::OrderStatus::OPEN
                  }
                )

              subject
            end
          end

          context "when the new status should be candidates screened" do
            let(:existing_status) do
              JobOrders::Projectors::JobOrderExistingStatus::Projection.new(status: JobOrders::OrderStatus::FILLED)
            end
            let(:new_status) do
              JobOrders::Projectors::JobOrderStatus::Projection.new(
                order_count: 2,
                criteria_met?: true,
                candidates: { one: :screened },
                not_filled?: false
              )
            end

            it "emits an candidates screened event" do
              expect(message_service)
                .to receive(:create_once_for_trace!)
                .with(
                  trace_id: message.trace_id,
                  stream: message.stream,
                  schema: JobOrders::Events::StatusUpdated::V1,
                  data: {
                    status: JobOrders::OrderStatus::CANDIDATES_SCREENED
                  }
                )

              subject
            end
          end

          context "when the new status should be stalled" do
            let(:existing_status) do
              JobOrders::Projectors::JobOrderExistingStatus::Projection.new(status: JobOrders::OrderStatus::OPEN)
            end
            let(:new_status) do
              JobOrders::Projectors::JobOrderStatus::Projection.new(
                order_count: 2,
                criteria_met?: true,
                candidates: { one: :recommended, two: :recommended },
                not_filled?: false
              )
            end

            it "emits an waiting on employer event" do
              expect(message_service)
                .to receive(:create_once_for_trace!)
                .with(
                  trace_id: message.trace_id,
                  stream: message.stream,
                  schema: JobOrders::Events::StatusUpdated::V1,
                  data: {
                    status: JobOrders::OrderStatus::WAITING_ON_EMPLOYER
                  }
                )

              subject
            end
          end

          context "when the new status should be filled" do
            let(:existing_status) do
              JobOrders::Projectors::JobOrderExistingStatus::Projection.new(status: JobOrders::OrderStatus::OPEN)
            end
            let(:new_status) do
              JobOrders::Projectors::JobOrderStatus::Projection.new(
                order_count: 1,
                criteria_met?: true,
                candidates: { one: :hired },
                not_filled?: false
              )
            end

            it "emits an filled event" do
              expect(message_service)
                .to receive(:create_once_for_trace!)
                .with(
                  trace_id: message.trace_id,
                  stream: message.stream,
                  schema: JobOrders::Events::StatusUpdated::V1,
                  data: {
                    status: JobOrders::OrderStatus::FILLED
                  }
                )

              subject
            end
          end

          context "when the new status should be not filled" do
            let(:existing_status) do
              JobOrders::Projectors::JobOrderExistingStatus::Projection.new(status: JobOrders::OrderStatus::OPEN)
            end
            let(:new_status) do
              JobOrders::Projectors::JobOrderStatus::Projection.new(
                order_count: 1,
                criteria_met?: true,
                candidates: { one: :hired },
                not_filled?: true
              )
            end

            it "emits a not filled event" do
              expect(message_service)
                .to receive(:create_once_for_trace!)
                .with(
                  trace_id: message.trace_id,
                  stream: message.stream,
                  schema: JobOrders::Events::StatusUpdated::V1,
                  data: {
                    status: JobOrders::OrderStatus::NOT_FILLED
                  }
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
          schema: JobOrders::Events::CandidateAdded::V3,
          data: {
            person_id: SecureRandom.uuid
          },
          metadata: {
            requestor_type: nil,
            requestor_id: nil,
            requestor_email: nil
          }
        )
      end

      it_behaves_like "emits new status events if necessary"
    end

    context "when the message is job order candidate recommended" do
      let(:message) do
        build(
          :message,
          schema: JobOrders::Events::CandidateRecommended::V2,
          data: {
            person_id: SecureRandom.uuid
          }
        )
      end

      it_behaves_like "emits new status events if necessary"
    end

    context "when the message is job order closed not filled" do
      let(:message) do
        build(
          :message,
          schema: JobOrders::Events::ClosedNotFilled::V1,
          data: Core::Nothing
        )
      end

      it_behaves_like "emits new status events if necessary"
    end

    context "when the message is job order reactivated" do
      let(:message) do
        build(
          :message,
          schema: JobOrders::Events::Reactivated::V1,
          data: Core::Nothing
        )
      end

      it_behaves_like "emits new status events if necessary"
    end

    context "when the message is job order candidate hired" do
      let(:message) do
        build(
          :message,
          schema: JobOrders::Events::CandidateHired::V2,
          data: {
            person_id: SecureRandom.uuid
          }
        )
      end

      it_behaves_like "emits new status events if necessary"
    end

    context "when the message is job order candidate rescinded" do
      let(:message) do
        build(
          :message,
          schema: JobOrders::Events::CandidateRescinded::V2,
          data: {
            person_id: SecureRandom.uuid
          }
        )
      end

      it_behaves_like "emits new status events if necessary"
    end

    context "when the message is job order candidate screened" do
      let(:message) do
        build(
          :message,
          schema: JobOrders::Events::CandidateScreened::V1,
          data: {
            person_id: SecureRandom.uuid
          }
        )
      end

      it_behaves_like "emits new status events if necessary"
    end

    context "when the message is job order added" do
      let(:message) do
        build(
          :message,
          schema: JobOrders::Events::OrderCountAdded::V1,
          data: {
            order_count: 2
          }
        )
      end

      it_behaves_like "emits new status events if necessary"
    end

    context "when the message is job order criteria added" do
      let(:message) do
        build(
          :message,
          schema: JobOrders::Events::CriteriaAdded::V1,
          data: Core::Nothing
        )
      end

      it_behaves_like "emits new status events if necessary"
    end
  end
end
