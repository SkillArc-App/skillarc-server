require 'rails_helper'

RSpec.describe Projections::Trace::HasOccurred do
  describe ".project" do
    subject { described_class.project(trace_id:, schema:) }

    let(:user_id) { SecureRandom.uuid }
    let(:trace_id) { SecureRandom.uuid }
    let(:schema) { Events::SessionStarted::V1 }

    context "when the event does not exist for the aggregate" do
      before do
        Event.from_message!(
          build(
            :message,
            schema: Events::SeekerCreated::V1,
            trace_id:,
            data: {
              id: SecureRandom.uuid,
              user_id:
            }
          )
        )
        Event.from_message!(
          build(
            :message,
            schema: Events::SessionStarted::V1,
            aggregate_id: SecureRandom.uuid,
            data: Messages::Nothing
          )
        )
      end

      it "returns false" do
        expect(subject).to eq(false)
      end
    end

    context "when the event does exist for the aggregate" do
      before do
        Event.from_message!(
          build(
            :message,
            schema: Events::SeekerCreated::V1,
            trace_id:,
            data: {
              id: SecureRandom.uuid,
              user_id:
            }
          )
        )
        Event.from_message!(
          build(
            :message,
            schema: Events::SessionStarted::V1,
            trace_id:,
            data: Messages::Nothing
          )
        )
      end

      it "returns true" do
        expect(subject).to eq(true)
      end
    end
  end
end
