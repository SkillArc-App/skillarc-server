require 'rails_helper'

RSpec.describe Employers::ApplicationNotificationService do
  it_behaves_like "an event consumer"

  describe "application created" do
    subject { described_class.handle_event(applicant_status_updated) }

    let(:applicant_status_updated) { build(:events__message, :applicant_status_updated, version: 3, data:) }
    let(:data) do
      Events::ApplicantStatusUpdated::Data::V3.new(
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

      applicant = Employers::Applicant.last_created

      expect(applicant.first_name).to eq(data.applicant_first_name)
      expect(applicant.last_name).to eq(data.applicant_last_name)
      expect(applicant.email).to eq(data.applicant_email)
      expect(applicant.phone_number).to eq(data.applicant_phone_number)
      expect(applicant.status).to eq(data.status)
      expect(applicant.job).to eq(job)
      expect(applicant.seeker_id).to eq(data.seeker_id)
      expect(applicant.status_as_of).to eq(applicant_status_updated.occurred_at)
    end

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
