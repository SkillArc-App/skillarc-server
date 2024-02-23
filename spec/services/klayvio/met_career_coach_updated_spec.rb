require 'rails_helper'

RSpec.describe Klayvio::MetCareerCoachUpdated do
  describe "#call" do
    subject { described_class.new.call(message:) }

    let(:message) do
      build(
        :message,
        :met_career_coach_updated,
        aggregate_id: user.id,
        data: Messages::UntypedHashWrapper.new(
          met_career_coach: true
        )
      )
    end
    let(:user) { create(:user, email:) }
    let(:email) { Faker::Internet.email }

    it "calls the Klayvio API" do
      expect_any_instance_of(Klayvio::Klayvio).to receive(:met_with_career_coach_updated).with(
        email:,
        event_id: message.id,
        occurred_at: message.occurred_at,
        profile_properties: {
          met_career_coach: true
        }
      )

      subject
    end
  end
end
