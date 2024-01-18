require 'rails_helper'

RSpec.describe Klayvio::OnboardingComplete do
  describe "#call" do
    let(:event) do
      build(
        :event_message,
        :onboarding_complete,
        aggregate_id: user.id
      )
    end
    let(:user) { create(:user, email:) }
    let(:email) { "tom@blocktrainapp.com" }
    let(:occurred_at) { Date.new(2020, 1, 1) }

    it "calls the Klayvio API" do
      expect_any_instance_of(Klayvio::Klayvio).to receive(:onboarding_complete).with(
        email:,
        event_id: event.id,
        occurred_at: event.occurred_at
      )

      subject.call(event:)
    end
  end
end
