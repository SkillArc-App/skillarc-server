require 'rails_helper'

RSpec.describe Projectors::Aggregates::GetLast do
  describe ".project" do
    subject { described_class.project(aggregate:, schema:) }

    let(:user_id) { SecureRandom.uuid }
    let(:aggregate) { Aggregates::User.new(user_id:) }
    let(:schema) { Events::ProfileCreated::V1 }

    context "when the event does not exist for the aggregate" do
      before do
        Event.from_message!(message1)
        Event.from_message!(message2)
      end

      let(:message1) do
        build(
          :message,
          schema: Events::ProfileCreated::V1,
          aggregate_id: SecureRandom.uuid,
          data: {
            id: SecureRandom.uuid,
            user_id:
          }
        )
      end
      let(:message2) do
        build(
          :message,
          schema: Events::SessionStarted::V1,
          aggregate_id: user_id,
          data: Messages::Nothing
        )
      end

      it "returns nil" do
        expect(subject).to eq(nil)
      end
    end

    context "when the event does exist for the aggregate" do
      before do
        Event.from_message!(message1)
        Event.from_message!(message2)
      end

      let(:message1) do
        build(
          :message,
          schema: Events::ProfileCreated::V1,
          aggregate_id: user_id,
          data: {
            id: id1,
            user_id: id1
          },
          occurred_at: Time.zone.local(2000, 10, 10)
        )
      end
      let(:message2) do
        build(
          :message,
          schema: Events::ProfileCreated::V1,
          aggregate_id: user_id,
          data: {
            id: id2,
            user_id: id2
          },
          occurred_at: Time.zone.local(2000, 10, 11)
        )
      end

      let(:id1) { SecureRandom.uuid }
      let(:id2) { SecureRandom.uuid }

      it "returns the second message" do
        expect(subject).to eq(message2)
      end
    end
  end
end
