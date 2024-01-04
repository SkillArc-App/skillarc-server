require 'rails_helper'

RSpec.describe Klayvio::ApplicationStatusUpdated do
  describe "#call" do
    let(:event) do
      build(
        :event,
        :applicant_status_updated,
        aggregate_id: job.id,
        data: {
          applicant_id: applicant.id,
          status: "new"
        }
      )
    end
    let(:job) { create(:job) }
    let(:applicant) { create(:applicant, job:, profile:) }
    let(:profile) { create(:profile, user:) }
    let(:user) { create(:user, email: "tom@blocktrainapp.com") }

    it "calls the Klayvio API" do
      expect_any_instance_of(Klayvio::Klayvio).to receive(:application_status_updated).with(
        application_id: applicant.id,
        email: user.email,
        employment_title: job.employment_title,
        employer_name: job.employer.name,
        event_id: event.id,
        occurred_at: event.occurred_at,
        status: "new"
      )

      subject.call(event:)
    end
  end
end
