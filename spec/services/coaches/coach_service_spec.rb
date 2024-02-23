require 'rails_helper'

RSpec.describe Coaches::CoachService do
  let(:role_added) do
    build(
      :message,
      :role_added,
      aggregate_id: user_id,
      data: Messages::UntypedHashWrapper.build(
        coach_id:,
        role: "coach",
        email: "coach@blocktrainapp.com"
      )
    )
  end
  let(:other_role_added) { build(:message, :role_added, aggregate_id: user_id, data: Messages::UntypedHashWrapper.build(role: "admin", email: "not_coach@blocktrainapp.com")) }
  let(:user_id) { SecureRandom.uuid }
  let(:coach_id) { SecureRandom.uuid }
  let(:consumer) { described_class.new }

  before do
    consumer.handle_message(role_added)
    consumer.handle_message(other_role_added)
  end

  it_behaves_like "an event consumer"

  describe ".all" do
    subject { consumer.all }

    it "returns all coaches" do
      expected_coach = {
        id: coach_id,
        email: "coach@blocktrainapp.com"
      }

      expect(subject).to contain_exactly(expected_coach)
    end
  end

  describe ".reset_for_replay" do
    it "destroys all records" do
      expect(Coaches::Coach.count).not_to eq(0)

      consumer.reset_for_replay

      expect(Coaches::Coach.count).to eq(0)
    end
  end
end
