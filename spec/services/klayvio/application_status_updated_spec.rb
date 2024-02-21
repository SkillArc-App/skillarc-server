require 'rails_helper'

RSpec.describe Klayvio::ApplicationStatusUpdated do
  describe "#call" do
    let(:message) do
      build(
        :message,
        :applicant_status_updated,
        version: 3,
        aggregate_id: job.id,
        data: Events::ApplicantStatusUpdated::Data::V3.new(
          applicant_id: applicant.id,
          applicant_first_name: "John",
          applicant_last_name: "Chabot",
          applicant_email: "john@skillar.com",
          profile_id: SecureRandom.uuid,
          seeker_id: SecureRandom.uuid,
          user_id: SecureRandom.uuid,
          job_id: SecureRandom.uuid,
          employer_name: "A employer",
          employment_title: "A title",
          status: "new"
        )
      )
    end
    let(:job) { create(:job) }
    let(:applicant) { create(:applicant, job:, seeker:) }
    let(:seeker) { create(:seeker, user:) }
    let(:user) { create(:user, email: "tom@blocktrainapp.com") }

    it "calls the Klayvio API" do
      expect_any_instance_of(Klayvio::Klayvio).to receive(:application_status_updated).with(
        application_id: applicant.id,
        email: user.email,
        employment_title: job.employment_title,
        employer_name: job.employer.name,
        event_id: message.id,
        occurred_at: message.occurred_at,
        status: "new"
      )

      subject.call(message:)
    end
  end
end
