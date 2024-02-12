require 'rails_helper'

RSpec.describe Slack::UserSignup do
  describe "#call" do
    let(:message) do
      build(
        :events__message,
        :user_created,
        data: Events::Common::UntypedHashWrapper.new(
          email:
        )
      )
    end
    let(:email) { Faker::Internet.email }

    it "calls the Slack API" do
      expect_any_instance_of(Slack::FakeSlackGateway).to receive(:ping).with(
        "New user signed up: *#{email}*"
      )

      subject.call(message:)
    end
  end
end
