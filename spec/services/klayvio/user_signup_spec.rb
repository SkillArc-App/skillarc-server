require 'rails_helper'

RSpec.describe Klayvio::UserSignup do
  describe "#call" do
    let(:message) do
      build(:message, :user_created, data: Events::UserCreated::Data::V1.new)
    end
    let(:email) { "tom@blocktrainapp.com" }
    let(:occurred_at) { Date.new(2020, 1, 1) }

    it "calls the Klayvio API" do
      expect_any_instance_of(Klayvio::FakeGateway).to receive(:user_signup).with(
        email: message.data[:email],
        event_id: message.id,
        occurred_at: message.occurred_at
      )

      subject.call(message:)
    end
  end
end
