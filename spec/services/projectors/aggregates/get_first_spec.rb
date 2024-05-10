require 'rails_helper'

RSpec.describe Projectors::Aggregates::GetFirst do
  describe ".project" do
    subject { described_class.project(aggregate:, schema:) }

    let(:seeker_id) { SecureRandom.uuid }
    let(:aggregate) { Aggregates::Seeker.new(seeker_id:) }
    let(:schema) { Events::SeekerCreated::V1 }

    context "when the event does not exist for the aggregate" do
      before do
        Event.from_message!(message1)
        Event.from_message!(message2)
      end

      let(:message1) do
        build(
          :message,
          schema: Events::SeekerCreated::V1,
          aggregate_id: SecureRandom.uuid,
          data: {
            user_id: SecureRandom.uuid
          }
        )
      end
      let(:message2) do
        build(
          :message,
          schema: Events::ZipAdded::V1,
          aggregate_id: seeker_id,
          data: {
            zip_code: "43202"
          }
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
          schema: Events::SeekerCreated::V1,
          aggregate_id: seeker_id,
          data: {
            user_id: SecureRandom.uuid
          },
          occurred_at: Time.zone.local(2000, 10, 10)
        )
      end
      let(:message2) do
        build(
          :message,
          schema: Events::SeekerCreated::V1,
          aggregate_id: seeker_id,
          data: {
            user_id: SecureRandom.uuid
          },
          occurred_at: Time.zone.local(2000, 10, 11)
        )
      end

      it "returns the first message" do
        expect(subject).to eq(message1)
      end
    end
  end
end
