require 'rails_helper'

RSpec.describe Employers::ApplicationNotificationService do
  it_behaves_like "an event consumer"

  describe "application created" do
    subject { described_class.handle_event(applicant_status_updated) }

    let(:applicant_status_updated) { build(:events__message, :applicant_status_updated, version: 2, data:) }
    let(:data) do
      Events::ApplicantStatusUpdated::Data::V2.new(
        applicant_id: SecureRandom.uuid,
        applicant_first_name: "first_name",
        applicant_last_name: "last_name",
        applicant_email: "email",
        applicant_phone_number: "phone_number",
        profile_id: SecureRandom.uuid,
        seeker_id: SecureRandom.uuid,
        user_id: "user_id",
        job_id:,
        employer_name: "employer_name",
        employment_title: "employment_title",
        status:
      )
    end
    let(:status) { ApplicantStatus::StatusTypes::NEW }

    let(:job) { create(:employers_job) }
    let(:job_id) { job.job_id }

    let!(:recruiter) { create(:employers_recruiter, employer: job.employer) }

    it "creates the records" do
      expect { subject }
        .to change { Employers::Applicant.count }.by(1)
    end

    it "sends an email to the employer" do
      expect_any_instance_of(Contact::SmtpService)
        .to receive(:notify_employer_of_applicant)
        .with(be_a(Employers::Job), be_a(Employers::Applicant))
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
