require 'rails_helper'

RSpec.describe Employers::EmployerService do
  it_behaves_like "an event consumer"

  describe "application created" do
    let(:employer_created) do
      build(
        :message,
        :employer_created,
        aggregate_id: employer_id,
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
        :message,
        :employer_updated,
        aggregate_id: employer_id,
        data: Events::EmployerUpdated::Data::V1.new(
          name: "name",
          location: "location",
          bio: "bio",
          logo_url: "logo_url"
        )
      )
    end
    let(:employer_invite_accepted) do
      build(
        :message,
        :employer_invite_accepted,
        data: Events::EmployerInviteAccepted::Data::V1.new(
          employer_invite_id: SecureRandom.uuid,
          invite_email: "invite_email",
          employer_id:,
          employer_name: "employer_name"
        )
      )
    end
    let(:job_created) do
      build(
        :message,
        :job_created,
        aggregate_id: job_id,
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
    let(:job_updated) do
      build(
        :message,
        :job_updated,
        aggregate_id: job_id,
        data: Events::JobUpdated::Data::V1.new(
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
    let(:applicant_status_updated) do
      build(:message, :applicant_status_updated, version: 4, data: Events::ApplicantStatusUpdated::Data::V4.new(
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
        status: ApplicantStatus::StatusTypes::NEW,
        reasons: [
          Events::ApplicantStatusUpdated::Reason::V2.new(
            id: SecureRandom.uuid,
            response: "response",
            reason_description: "reason_description"
          )
        ]
      ))
    end

    let(:employer_id) { SecureRandom.uuid }
    let(:job_id) { SecureRandom.uuid }

    let(:status) { ApplicantStatus::StatusTypes::NEW }

    it "creates the records" do
      consumer = described_class.new

      expect do
        consumer.handle_message(employer_created)
        consumer.handle_message(employer_updated)
        consumer.handle_message(employer_invite_accepted)
        consumer.handle_message(job_created)
        consumer.handle_message(job_updated)
        consumer.handle_message(applicant_status_updated)
      end
        .to change { Employers::Job.count }.by(1)
        .and change { Employers::Employer.count }.by(1)
        .and change { Employers::Recruiter.count }.by(1)
        .and change { Employers::Applicant.count }.by(1)
        .and change { Employers::ApplicantStatusReason.count }.by(1)

      expect(Employers::Applicant.last_created).to have_attributes(
        first_name: "first_name",
        last_name: "last_name",
        email: "email",
        phone_number: "phone_number",
        status:,
        job: Employers::Job.last_created,
        seeker_id: applicant_status_updated.data.seeker_id,
        status_as_of: applicant_status_updated.occurred_at
      )

      expect(Employers::ApplicantStatusReason.last_created).to have_attributes(
        applicant: Employers::Applicant.last_created,
        reason: "reason_description",
        response: "response"
      )

      expect(Employers::Job.last_created).to have_attributes(
        employment_title: "employment title",
        benefits_description: "benefits description",
        responsibilities_description: "responsibilities description",
        location: "location",
        employment_type: Job::EmploymentTypes::FULLTIME,
        hide_job: false,
        schedule: "9-5"
      )

      expect(Employers::Employer.last_created).to have_attributes(
        name: "name",
        location: "location",
        bio: "bio",
        logo_url: "logo_url"
      )

      expect(Employers::Recruiter.last_created).to have_attributes(
        employer: Employers::Employer.last_created,
        email: "invite_email"
      )

      recruiter = Employers::Recruiter.last_created

      expect do
        consumer.handle_message(
          build(
            :message,
            :job_owner_assigned,
            data: Events::JobOwnerAssigned::Data::V1.new(
              job_id:,
              owner_email: recruiter.email
            )
          )
        )
      end.to change { Employers::JobOwner.count }.by(1)
    end
  end
end
