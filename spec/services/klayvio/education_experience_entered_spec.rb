require 'rails_helper'

RSpec.describe Klayvio::EducationExperienceEntered do
  describe "#call" do
    let(:event) do
      build(
        :events__message,
        :education_experience_created,
        aggregate_id: user.id
      )
    end
    let(:user) { create(:user, email:) }
    let(:email) { "tom@blocktrainapp.com" }
    let(:occurred_at) { Date.new(2020, 1, 1) }

    it "calls the Klayvio API" do
      expect_any_instance_of(Klayvio::Klayvio).to receive(:education_experience_entered).with(
        email:,
        event_id: event.id,
        occurred_at: event.occurred_at
      )

      subject.call(event:)
    end
  end
end
