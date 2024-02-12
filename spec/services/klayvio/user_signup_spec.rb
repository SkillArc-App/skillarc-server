require 'rails_helper'

RSpec.describe Klayvio::UserSignup do
  describe "#call" do
    let(:message) do
      build(:events__message, :user_created)
    end
    let(:email) { "tom@blocktrainapp.com" }
    let(:occurred_at) { Date.new(2020, 1, 1) }

    it "calls the Klayvio API" do
      expect_any_instance_of(Klayvio::Klayvio).to receive(:user_signup).with(
        email: message.data[:email],
        event_id: message.id,
        occurred_at: message.occurred_at
      )

      subject.call(message:)
    end
  end
end
