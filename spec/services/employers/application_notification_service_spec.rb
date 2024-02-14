require 'rails_helper'

RSpec.describe Employers::ApplicationNotificationService do
  it_behaves_like "an event consumer"

  describe "application created" do
    subject { described_class.handle_event(applicant_status_updated) }

    let(:employer_created) do
      build(
        :events__message,
        :employer_created,
        data: Events::EmployerCreated::Data::V1.new(
          name: "name",
          location: "location",
          bio: "bio",
          logo_url: "logo_url"
        )
      )
    end
    let(:employer_updated) do
      build(
        :events__message,
        :employer_updated,
        data: Events::EmployerUpdated::Data::V1.new(
          name: "name",
          location: "location",
          bio: "bio",
          logo_url: "logo_url"
        )
      )
    end
    let(:employer_invite_accepted) { build(:events__message, :employer_invite_accepted) }
    let(:job_created) do
      build(
        :events__message,
        :job_created,
        data: Events::JobCreated::Data::V1.new(
          employer_id:,
          employment_title: "employment title",
          benefits_description: "benefits description",
          responsibilities_description: "responsibilities description",
          location: "location",
          employment_type: Job::EmploymentTypes::FULLTIME,
          hide_job: false,
          schedule: "9-5",
          work_days: "M-F",
          requirements_description: "requirements description",
          industry: [Job::Industries::MANUFACTURING]
        )
      )
    end
    let(:job_updated) { build(:events__message, :job_updated) }

    let(:employer_id) { SecureRandom.uuid }

    before do
      described_class.handle_event(employer_created)
      described_class.handle_event(employer_updated)
      described_class.handle_event(employer_invite_accepted)
      described_class.handle_event(job_created)
      described_class.handle_event(job_updated)
    end

    let(:applicant_status_updated) { build(:events__message, :applicant_status_updated, data:) }
    let(:data) do
      Events::ApplicantStatusUpdated::Data::V1.new(
        applicant_id: SecureRandom.uuid,
        profile_id: SecureRandom.uuid,
        seeker_id: SecureRandom.uuid,
        user_id: "user_id",
        job_id: SecureRandom.uuid,
        employer_name: "employer_name",
        employment_title: "employment_title",
        status:
      )
    end
    let(:status) { ApplicantStatus::StatusTypes::NEW }

    context "for the first time" do
      it "sends an email to the employer" do
        expect(EmployerApplicantNotificationMailer).to receive(:notify_employer).and_call_original

        subject
      end
    end

    context "not for the first time" do
      it "does not send an email to the employer"
    end
  end
end
