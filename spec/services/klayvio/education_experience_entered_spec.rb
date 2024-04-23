require 'rails_helper'

RSpec.describe Klayvio::EducationExperienceEntered do
  describe "#call" do
    let(:message) do
      build(
        :message,
        schema: Events::EducationExperienceAdded::V1,
        aggregate_id: seeker.id,
        data: {
          id: SecureRandom.uuid,
          organization_name: "A organization",
          title: "A title",
          activities: nil,
          graduation_date: Time.zone.now.to_s,
          gpa: "1.89"
        }
      )
    end
    let(:user) { create(:user, email:) }
    let(:seeker) { create(:seeker, user:) }
    let(:email) { "tom@blocktrainapp.com" }
    let(:occurred_at) { Date.new(2020, 1, 1) }

    it "calls the Klayvio API" do
      expect_any_instance_of(Klayvio::FakeGateway).to receive(:education_experience_entered).with(
        email:,
        event_id: message.id,
        occurred_at: message.occurred_at
      )

      subject.call(message:)
    end
  end
end
