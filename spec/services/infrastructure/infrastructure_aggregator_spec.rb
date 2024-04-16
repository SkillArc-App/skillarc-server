require 'rails_helper'

RSpec.describe Infrastructure::InfrastructureAggregator do
  it_behaves_like "a message consumer"

  describe "#handle_message" do
    subject { described_class.new.handle_message(message) }

    context "when the message is command scheduled" do
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
          schema: Events::CommandScheduled::V1,
          aggregate_id: SecureRandom.uuid,
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

      it "creates a scheduled command" do
        expect { subject }.to change(Infrastructure::ScheduledCommand, :count).from(0).to(1)

        scheduled_command = Infrastructure::ScheduledCommand.take(1).first

        expect(scheduled_command.execute_at).to eq(Time.zone.local(2000, 1, 1))
        expect(scheduled_command.message).to eq(inner_message)
        expect(scheduled_command.task_id).to eq(message.aggregate.task_id)
        expect(scheduled_command.state).to eq(Infrastructure::ScheduledCommand::State::ENQUEUED)
      end
    end

    context "when the message is Scheduled Commands Executed" do
      let!(:scheduled_command) { create(:infrastructure__scheduled_command, task_id:) }

      let(:message) do
        build(
          :message,
          schema: Events::ScheduledCommandExecuted::V1,
          aggregate_id: task_id,
          data: Messages::Nothing
        )
      end
      let(:task_id) { SecureRandom.uuid }

      it "updates an existing command to status executed" do
        expect { subject }.not_to change(Infrastructure::ScheduledCommand, :count)

        scheduled_command = Infrastructure::ScheduledCommand.take(1).first
        expect(scheduled_command.state).to eq(Infrastructure::ScheduledCommand::State::EXECUTED)
      end
    end
  end
end
