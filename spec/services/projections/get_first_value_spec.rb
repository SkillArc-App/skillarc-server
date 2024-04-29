require 'rails_helper'

RSpec.describe Projections::GetFirstValue do
  describe ".project" do
    subject { described_class.project(aggregate:, schema:, attribute:) }

    let(:user_id) { SecureRandom.uuid }
    let(:aggregate) { Aggregates::User.new(user_id:) }
    let(:schema) { Events::SeekerCreated::V1 }
    let(:attribute) { :user_id }

    context "when the event does not exist for the aggregate" do
      before do
        Event.from_message!(
          build(
            :message,
            schema: Events::SeekerCreated::V1,
            aggregate_id: SecureRandom.uuid,
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
            aggregate_id: user_id,
            data: Messages::Nothing
          )
        )
      end

      it "returns nil" do
        expect(subject).to eq(nil)
      end
    end

    context "when the event does exist for the aggregate" do
      before do
        Event.from_message!(
          build(
            :message,
            schema: Events::SeekerCreated::V1,
            aggregate_id: user_id,
            data: {
              id: id1,
              user_id: id1
            },
            occurred_at: 2.minutes.ago
          )
        )
        Event.from_message!(
          build(
            :message,
            schema: Events::SeekerCreated::V1,
            aggregate_id: user_id,
            data: {
              id: id2,
              user_id: id2
            },
            occurred_at: 1.minute.ago
          )
        )
      end

      let(:id1) { SecureRandom.uuid }
      let(:id2) { SecureRandom.uuid }

      it "returns the first id" do
        expect(subject).to eq(id1)
      end
    end
  end
end
