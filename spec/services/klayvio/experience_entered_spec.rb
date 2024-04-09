require 'rails_helper'

RSpec.describe Klayvio::ExperienceEntered do
  describe "#call" do
    let(:message) do
      build(
        :message,
        :experience_created,
        aggregate_id: user.id,
        data: {
          id: SecureRandom.uuid,
          organization_name: "A name",
          position: "A position",
          start_date: Time.zone.now.to_s,
          end_date: nil,
          description: "A description",
          is_current: false,
          profile_id: SecureRandom.uuid,
          seeker_id: SecureRandom.uuid
        }
      )
    end
    let(:user) { create(:user, email:) }
    let(:email) { "tom@blocktrainapp.com" }
    let(:occurred_at) { Date.new(2020, 1, 1) }

    it "calls the Klayvio API" do
      expect_any_instance_of(Klayvio::FakeGateway).to receive(:experience_entered).with(
        email:,
        event_id: message.id,
        occurred_at: message.occurred_at
      )

      subject.call(message:)
    end
  end
end
