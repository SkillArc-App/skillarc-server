require 'rails_helper'

RSpec.describe Employers::EmployerService do
  it_behaves_like "an event consumer"

  describe "application created" do
    let(:employer_created) do
      build(
        :events__message,
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
        :events__message,
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
        :events__message,
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
        :events__message,
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
        :events__message,
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

    let(:employer_id) { SecureRandom.uuid }
    let(:job_id) { SecureRandom.uuid }

    let(:status) { ApplicantStatus::StatusTypes::NEW }

    it "creates the records" do
      expect do
        described_class.handle_event(employer_created)
        described_class.handle_event(employer_updated)
        described_class.handle_event(employer_invite_accepted)
        described_class.handle_event(job_created)
        described_class.handle_event(job_updated)
      end
        .to change { Employers::Job.count }.by(1)
        .and change { Employers::Employer.count }.by(1)
        .and change { Employers::Recruiter.count }.by(1)

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
        described_class.handle_event(
          build(
            :events__message,
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
