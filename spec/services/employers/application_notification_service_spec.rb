require 'rails_helper'

RSpec.describe Employers::ApplicationNotificationService do
  it_behaves_like "an event consumer"

  describe "application created" do
    subject { described_class.handle_event(applicant_status_updated) }

    let(:applicant_status_updated) { build(:events__message, :applicant_status_updated, version: 3, data:) }
    let(:data) do
      Events::ApplicantStatusUpdated::Data::V3.new(
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
        .with(be_a(Employers::Job), job.owner_emails.first, be_a(Employers::Applicant))
        .and_call_original

      subject
    end

    context "when with side effects is false" do
      it "does not send an email to the employer" do
        expect_any_instance_of(Contact::SmtpService)
          .not_to receive(:notify_employer_of_applicant)

        described_class.handle_event(applicant_status_updated, with_side_effects: false)
      end
    end
  end
end
