require 'rails_helper'

RSpec.describe ExecuteScheduledCommandsJob do
  let!(:scheduled_command1) { create(:infastructure__scheduled_command, message: message1) }
  let!(:scheduled_command2) { create(:infastructure__scheduled_command, message: message2) }

  let(:message1) do
    build(
      :message,
      schema: Commands::AssignCoach::V1,
      aggregate_id: SecureRandom.uuid,
      data: {
        coach_email: "coach1@skillarc.com"
      }
    )
  end
  let(:message2) do
    build(
      :message,
      schema: Commands::AssignCoach::V1,
      aggregate_id: SecureRandom.uuid,
      data: {
        coach_email: "coach2@skillarc.com"
      }
    )
  end

  it "enqueues each ready to be executed command" do
    expect_any_instance_of(MessageService)
      .to receive(:create!)
      .with(
        schema: message1.schema,
        data: message1.data,
        trace_id: message1.trace_id,
        context_id: message1.aggregate.id,
        id: message1.id,
        metadata: message1.metadata
      )
      .and_call_original

    expect_any_instance_of(MessageService)
      .to receive(:create!)
      .with(
        schema: Events::ScheduledCommandsExecuted::V1,
        data: Messages::Nothing,
        trace_id: message1.trace_id,
        task_id: scheduled_command1.task_id
      )
      .and_call_original

    expect_any_instance_of(MessageService)
      .to receive(:create!)
      .with(
        schema: message2.schema,
        data: message2.data,
        trace_id: message2.trace_id,
        context_id: message2.aggregate.id,
        id: message2.id,
        metadata: message2.metadata
      )
      .and_call_original

    expect_any_instance_of(MessageService)
      .to receive(:create!)
      .with(
        schema: Events::ScheduledCommandsExecuted::V1,
        data: Messages::Nothing,
        trace_id: message2.trace_id,
        task_id: scheduled_command2.task_id
      )
      .and_call_original

    described_class.new.perform
  end
end
