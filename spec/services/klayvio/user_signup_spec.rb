require 'rails_helper'

RSpec.describe Klayvio::UserSignup do
  describe "#call" do
    let(:event) do
      build(:event, :user_created)
    end
    let(:email) { "tom@blocktrainapp.com" }
    let(:occurred_at) { Date.new(2020, 1, 1) }

    it "calls the Klayvio API" do
      expect_any_instance_of(Klayvio::Klayvio).to receive(:user_signup).with(
        email: event.data["email"],
        event_id: event.id,
        occurred_at: event.occurred_at
      )

      subject.call(event:)
    end
  end
end
