require 'rails_helper'

RSpec.describe Infastructure::ScheduledCommand do
  let(:instance) do
    create(
      :infastructure__scheduled_command,
      state:,
      task_id:,
      message:
    )
  end
  let(:state) { described_class::State::ENQUEUED }
  let(:task_id) { SecureRandom.uuid }
  let(:message) do
    build(
      :message,
      schema: Commands::AssignCoach::V1,
      aggregate_id: SecureRandom.uuid,
      data: {
        coach_email: "coach@skillarc.com"
      }
    )
  end

  describe "#message" do
    it "returns the message it was created with" do
      expect(instance.message).to eq(message)
    end
  end

  describe "#cancel!" do
    context "when state is not enqueued" do
      let(:state) { described_class::State::EXECUTED }

      it "sets the state to cancelled" do
        instance.cancel!
        expect(instance.state).to eq(state)
      end
    end

    context "when state is enqueued" do
      let(:state) { described_class::State::ENQUEUED }

      it "sets the state to cancelled" do
        instance.cancel!
        expect(instance.state).to eq(described_class::State::CANCELLED)
      end
    end
  end

  describe "#execute!" do
    let(:message_service) { MessageService.new }

    context "when state is enqueued" do
      let(:state) { described_class::State::ENQUEUED }

      it "executes the command and sets the state to executed" do
        expect(message_service)
          .to receive(:create!)
          .with(
            schema: message.schema,
            data: message.data,
            trace_id: message.trace_id,
            context_id: message.aggregate.id,
            id: message.id,
            metadata: message.metadata
          )
          .and_call_original

        instance.execute!(message_service)
        expect(instance.state).to eq(described_class::State::EXECUTED)
      end
    end

    context "when state is not enqueued" do
      let(:state) { described_class::State::CANCELLED }

      it "does nothing" do
        expect(message_service)
          .not_to receive(:create!)

        instance.execute!(message_service)
        expect(instance.state).to eq(state)
      end
    end
  end
end
