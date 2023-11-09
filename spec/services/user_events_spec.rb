require 'rails_helper'

RSpec.describe UserEvents do
  describe "#all" do
    subject { described_class.new(user).all }

    let(:user) { create(:user) }

    let!(:event) { create(:event, :user_created, occurred_at: occurred_at, aggregate_id: user.id) }
    let!(:other_event) { create(:event, :education_experience_created, aggregate_id: user.id) }

    let(:occurred_at) { Time.utc(2023, 12, 1) }

    it "returns the events" do
      expect(subject).to eq([{ datetime: '2023-12-01 12:00AM', event_message: "Signed Up" }])
    end
  end
end
