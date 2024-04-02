require 'rails_helper'

RSpec.describe Klayvio::OnboardingComplete do
  describe "#call" do
    let(:message) do
      build(
        :message,
        :onboarding_completed,
        aggregate_id: user.id,
        data: Events::OnboardingCompleted::Data::V1.new(
          name: {}
        )
      )
    end
    let(:user) { create(:user, email:) }
    let(:email) { "tom@blocktrainapp.com" }
    let(:occurred_at) { Date.new(2020, 1, 1) }

    it "calls the Klayvio API" do
      expect_any_instance_of(Klayvio::FakeGateway).to receive(:onboarding_complete).with(
        email:,
        event_id: message.id,
        occurred_at: message.occurred_at
      )

      subject.call(message:)
    end
  end
end
