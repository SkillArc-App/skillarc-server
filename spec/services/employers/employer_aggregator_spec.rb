require 'rails_helper'

RSpec.describe Employers::EmployerAggregator do
  it_behaves_like "a message consumer"

  describe "application created" do
    let(:employer_created) do
      build(
        :message,
        :employer_created,
        aggregate_id: employer_id,
        data: {
          name: "name",
          location: "location",
          bio: "bio",
          logo_url: "logo_url"
        }
      )
    end
    let(:employer_updated) do
      build(
        :message,
        :employer_updated,
        aggregate_id: employer_id,
        data: {
          name: "name",
          location: "location",
          bio: "bio",
          logo_url: "logo_url"
        }
      )
    end
    let(:employer_invite_accepted) do
      build(
        :message,
        :employer_invite_accepted,
        data: {
          employer_invite_id: SecureRandom.uuid,
          invite_email: "invite_email",
          employer_id:,
          employer_name: "employer_name"
        }
      )
    end
    let(:job_created) do
      build(
        :message,
        :job_created,
        aggregate_id: job_id,
        version: 3,
        data: {
          category: Job::Categories::MARKETPLACE,
          employer_id:,
          employer_name: "employer_name",
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
        }
      )
    end
    let(:job_updated) do
      build(
        :message,
        schema: Events::JobUpdated::V2,
        aggregate_id: job_id,
        data: {
          employment_title: "employment title",
          benefits_description: "benefits description",
          responsibilities_description: "responsibilities description",
          location: "location",
          category: Job::Categories::STAFFING,
          employment_type: Job::EmploymentTypes::FULLTIME,
          hide_job: false,
          schedule: "9-5",
          work_days: "M-F",
          requirements_description: "requirements description",
          industry: [Job::Industries::MANUFACTURING]
        }
      )
    end
    let(:applicant_status_updated) do
      build(:message,
            schema: Events::ApplicantStatusUpdated::V5,
            occurred_at: Time.zone.local(2019, 1, 1),
            data: {
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
            },
            metadata: Events::ApplicantStatusUpdated::MetaData::V1.new)
    end
    let(:seeker_certified) do
      build(:message, :seeker_certified, version: 1, data: {
              coach_email: "hannah@skillarc.com",
              coach_id: SecureRandom.uuid
            })
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
        consumer.handle_message(seeker_certified)
      end
        .to change { Employers::Job.count }.by(1)
        .and change { Employers::Employer.count }.by(1)
        .and change { Employers::Recruiter.count }.by(1)
        .and change { Employers::Applicant.count }.by(1)
        .and change { Employers::Seeker.count }.by(1)

      expect(Employers::Applicant.last_created).to have_attributes(
        first_name: "first_name",
        last_name: "last_name",
        email: "email",
        phone_number: "phone_number",
        status:,
        application_submit_at: Time.zone.local(2019, 1, 1),
        job: Employers::Job.last_created,
        seeker_id: applicant_status_updated.data.seeker_id,
        status_as_of: applicant_status_updated.occurred_at
      )

      expect(Employers::Job.last_created).to have_attributes(
        category: Job::Categories::STAFFING,
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

      expect(Employers::Seeker.last_created).to have_attributes(
        seeker_id: seeker_certified.aggregate_id,
        certified_by: "hannah@skillarc.com"
      )

      recruiter = Employers::Recruiter.last_created

      expect do
        consumer.handle_message(
          build(
            :message,
            :job_owner_assigned,
            data: {
              job_id:,
              owner_email: recruiter.email
            }
          )
        )
      end.to change { Employers::JobOwner.count }.by(1)
    end
  end
end
