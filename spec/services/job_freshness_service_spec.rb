require 'rails_helper'

RSpec.describe JobFreshnessService do
  before(:each) do
    JobFreshnessService.class_variable_set(:@@employers_with_recruiters, nil)
  end

  let(:base_job_events) { [job_created_at_event, employer_invite_accepted] }
  let(:employer_invite_accepted) do
    build(
      :event,
      :employer_invite_accepted,
      aggregate_id: employer_id,
      data: {}
    )
  end

  let(:now) { Time.new(2024, 1, 1) }
  let(:job_created_at_event) do
    build(
      :event,
      :job_created,
      aggregate_id: job_id,
      data: {
        employment_title: "Welder",
        employer_id: employer_id,
        benefits_description: "Benefits",
        responsibilities_description: "Responsibilities",
        location: "Columbus, OH",
        employment_type: "FULLTIME",
        hide_job: false,
        schedule: "9-5",
        work_days: "M-F",
        requirements_description: "Requirements",
        industry: "manufacturing"
      },
      occurred_at: job_created_at
    )
  end
  let(:job_created_at) { now - 4.weeks }
  let(:job_id) { "0cff79c1-fb70-4e02-9407-1572c25d8717" }
  let(:employer_id) { "dbd969af-df4f-4ec0-9c23-8549235354c4" }

  describe ".handle_event" do
    subject { described_class.handle_event(event, with_side_effects: with_side_effects, now: now) }

    let(:event) { job_created_at_event }
    let(:with_side_effects) { false }

    it "returns a hash of FreshnessContexts" do
      expect(subject[job_id].get).to be_a(JobFreshnessService::FreshnessContext)
    end

    context "when with side effects is false" do
      it "does not update the database" do
        expect { subject }.not_to change { JobFreshness.count }
      end
    end

    context "when with side effects is true" do
      let(:with_side_effects) { true }

      it "creates a JobFreshness" do
        expect { subject }.to change { JobFreshness.count }.by(1)

        expect(JobFreshness.last_created).to have_attributes(
          job_id: job_id,
          status: "stale",
          employment_title: "Welder",
        )
      end
    end
  end

  describe "#get" do
    subject { described_class.new(job_events, now: now).get }

    let(:job_events) { base_job_events }

    it "returns 'fresh'" do
      expect(subject).to eq(JobFreshnessService::FreshnessContext.new(
        applicants: {},
        employment_title: "Welder",
        job_id: job_id,
        hidden: false,
        recruiter_exists: true,
        status: "fresh",
      ))
    end

    context "when the job is hidden" do
      let(:job_events) { base_job_events + [job_hidden_event] }
      let(:job_hidden_event) do
        build(
          :event,
          :job_updated,
          aggregate_id: job_id,
          data: {
            employer_id: employer_id,
            hide_job: true,
          },
          occurred_at: job_created_at + 1.day
        )
      end

      it "returns 'stale'" do
        expect(subject).to eq(JobFreshnessService::FreshnessContext.new(
          applicants: {},
          job_id: job_id,
          hidden: true,
          recruiter_exists: true,
          status: "stale"
        ))
      end
    end

    context "when there are applicants with 'new' status" do
      let(:job_events) { base_job_events + [applicant_created_at_event] }
      let(:applicant_created_at_event) do
        build(
          :event,
          :applicant_status_updated,
          aggregate_id: SecureRandom.uuid,
          data: {
            applicant_id: SecureRandom.uuid,
            job_id: job_id,
            profile_id: SecureRandom.uuid,
            user_id: SecureRandom.uuid,
            employment_title: "Welder",
            status: "new"
          },
          occurred_at: applicant_created_at
        )
      end

      context "when the applicant was created more than 1 week ago" do
        let(:applicant_created_at) { now - 2.weeks }

        it "returns 'stale'" do
          expect(subject).to eq(JobFreshnessService::FreshnessContext.new(
            job_id: job_id,
            status: "stale",
            applicants: {
              applicant_created_at_event.data.fetch("applicant_id") => {
                last_updated_at: applicant_created_at
              }
            },
            employment_title: "Welder",
            hidden: false,
            recruiter_exists: true,
          ))
        end
      end
    end
    
    context "when the employer has no recruiters" do
      let(:base_job_events) { [job_created_at_event] }

      it "returns 'stale'" do
        expect(subject).to eq(JobFreshnessService::FreshnessContext.new(
          job_id: job_id,
          status: "stale",
          applicants: {},
          employment_title: "Welder",
          hidden: false,
          recruiter_exists: false,
        ))
      end
    end
  end
end
