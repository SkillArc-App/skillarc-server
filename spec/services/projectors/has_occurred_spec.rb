require 'rails_helper'

RSpec.describe Projectors::HasOccurred do
  describe "#project" do
    subject { described_class.new(schema:).project(messages) }

    let(:user_id) { SecureRandom.uuid }
    let(:trace_id) { SecureRandom.uuid }
    let(:schema) { Events::TaskExecuted::V1 }

    context "when the event does not exist for the trace id" do
      let(:messages) { [] }

      it "returns false" do
        expect(subject).to eq(false)
      end
    end

    context "when the event does exist" do
      let(:messages) do
        [
          build(
            :message,
            schema: Events::TaskExecuted::V1,
            trace_id:
          ),
          build(
            :message,
            schema: Events::SessionStarted::V1,
            trace_id:
          )
        ]
      end

      it "returns true" do
        expect(subject).to eq(true)
      end
    end
  end
end
