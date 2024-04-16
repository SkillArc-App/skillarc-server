require 'rails_helper'

RSpec.describe Infrastructure::ScheduledCommand do
  let(:instance) do
    create(
      :infrastructure__scheduled_command,
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
    context "when state is enqueued" do
      let(:state) { described_class::State::ENQUEUED }

      it "executes the command and sets the state to executed" do
        instance.execute!
        expect(instance.state).to eq(described_class::State::EXECUTED)
      end
    end

    context "when state is not enqueued" do
      let(:state) { described_class::State::CANCELLED }

      it "does nothing" do
        instance.execute!
        expect(instance.state).to eq(state)
      end
    end
  end
end
