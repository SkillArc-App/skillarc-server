require 'rails_helper'

RSpec.describe Klayvio::EducationExperienceEntered do
  describe "#call" do
    let(:message) do
      build(
        :message,
        :education_experience_created,
        aggregate_id: user.id,
        data: Events::EducationExperienceCreated::Data::V1.new(
          id: SecureRandom.uuid,
          organization_name: "A organization",
          title: "A title",
          activities: nil,
          graduation_date: Time.zone.now.to_s,
          gpa: "1.89",
          profile_id: SecureRandom.uuid,
          seeker_id: SecureRandom.uuid
        )
      )
    end
    let(:user) { create(:user, email:) }
    let(:email) { "tom@blocktrainapp.com" }
    let(:occurred_at) { Date.new(2020, 1, 1) }

    it "calls the Klayvio API" do
      expect_any_instance_of(Klayvio::Klayvio).to receive(:education_experience_entered).with(
        email:,
        event_id: message.id,
        occurred_at: message.occurred_at
      )

      subject.call(message:)
    end
  end
end
