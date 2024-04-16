require 'rails_helper'

RSpec.describe Infrastructure::InfrastructureReactor do
  it_behaves_like "a message consumer"

  describe "#handle_message" do
    subject { described_class.new(message_service:).handle_message(message) }

    let(:message_service) { MessageService.new }

    context "when the message is schedule command" do
      let(:inner_message) do
        build(
          :message,
          schema: Commands::ScreenApplicant::V1,
          aggregate_id: SecureRandom.uuid,
          data: Messages::Nothing
        )
      end

      let(:message) do
        build(
          :message,
          schema: Commands::ScheduleCommand::V1,
          aggregate_id: task_id,
          data: {
            execute_at: Time.zone.local(2000, 1, 1),
            message: inner_message
          },
          metadata: {
            requestor_type: Requestor::Kinds::USER,
            requestor_id: SecureRandom.uuid
          }
        )
      end
      let(:task_id) { SecureRandom.uuid }

      context "if a task id already exists" do
        before do
          create(:infrastructure__scheduled_command, task_id:)
        end

        it "does nothing" do
          expect(message_service)
            .to_not receive(:create!)

          subject
        end
      end

      context "if a task id doesn't already exists" do
        it "fires off a command scheduled event" do
          expect(message_service)
            .to receive(:create!)
            .with(
              schema: Events::CommandScheduled::V1,
              trace_id: message.trace_id,
              task_id: message.aggregate.task_id,
              data: {
                execute_at: message.data.execute_at,
                message: message.data.message
              }
            )

          subject
        end
      end
    end
  end
end
