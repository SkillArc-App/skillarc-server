require 'rails_helper'

RSpec.describe Coaches::CoachService do
  let(:role_added) do
    create(
      :event,
      :role_added,
      aggregate_id: user_id,
      data: {
        coach_id:,
        role: "coach",
        email: "coach@blocktrainapp.com"
      }
    )
  end
  let(:other_role_added) { create(:event, :role_added, aggregate_id: user_id, data: { role: "admin", email: "not_coach@blocktrainapp.com" }) }
  let(:user_id) { SecureRandom.uuid }
  let(:coach_id) { SecureRandom.uuid }

  before do
    described_class.handle_event(role_added)
    described_class.handle_event(other_role_added)
  end

  describe ".all" do
    subject { described_class.all }

    it "returns all coaches" do
      expected_coach = {
        id: Coaches::Coach.last_created.id,
        email: "coach@blocktrainapp.com"
      }

      expect(subject).to contain_exactly(expected_coach)
    end
  end
end
