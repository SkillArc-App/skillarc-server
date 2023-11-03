require 'rails_helper'

RSpec.describe Slack::UserSignup do
  describe "#call" do
    let(:event) do
      build(
        :event,
        :user_created,
        data: {
          email:
        }
      )
    end
    let(:email) { Faker::Internet.email }

    it "calls the Slack API" do
      expect_any_instance_of(Slack::FakeSlackGateway).to receive(:ping).with(
        "New user signed up: *#{email}*"
      )

      subject.call(event:)
    end
  end
end