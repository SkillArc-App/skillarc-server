require 'rails_helper'

RSpec.describe Employers::ApplicationNotificationService do
  it_behaves_like "an event consumer"

  describe "application created" do
    subject { described_class.new.handle_message(applicant_status_updated) }

    let(:applicant_status_updated) { build(:message, :applicant_status_updated, version: 4, data:) }
    let(:data) do
      Events::ApplicantStatusUpdated::Data::V4.new(
        applicant_id: applicant.applicant_id,
        applicant_first_name: applicant.first_name,
        applicant_last_name: applicant.last_name,
        applicant_email: applicant.email,
        applicant_phone_number: applicant.phone_number,
        profile_id: applicant.seeker_id,
        seeker_id: applicant.seeker_id,
        user_id: SecureRandom.uuid,
        job_id: applicant.job.job_id,
        employer_name: "employer_name",
        employment_title: "employment_title",
        status:
      )
    end
    let(:applicant) { create(:employers_applicant, job:) }
    let(:status) { ApplicantStatus::StatusTypes::NEW }

    let(:job) { create(:employers_job) }
    let(:job_id) { job.job_id }

    let!(:recruiter) { create(:employers_recruiter, employer: job.employer) }

    it "sends an email to the employer" do
      expect_any_instance_of(Contact::SmtpService)
        .to receive(:notify_employer_of_applicant)
        .with(
          be_a(Employers::Job),
          recruiter.email,
          have_attributes(
            applicant_id: applicant.applicant_id,
            first_name: applicant.first_name,
            last_name: applicant.last_name,
            email: applicant.email,
            phone_number: applicant.phone_number,
            seeker_id: applicant.seeker_id,
            status:,
            status_as_of: applicant_status_updated.occurred_at
          )
        )
        .and_call_original

      subject
    end
  end
end
