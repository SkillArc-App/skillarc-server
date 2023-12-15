require 'rails_helper'

RSpec.describe JobFreshnessService do
  let(:base_job_events) { [job_created_at_event] }
  let(:now) { Time.new(2024, 1, 1) }
  let(:job_created_at_event) do
    build(
      :event,
      :job_created,
      aggregate_id: job_id,
      data: {
        employment_title: "Welder",
        employer_id: SecureRandom.uuid,
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
  let(:job_id) { "1" }

  describe ".persist_all" do
    subject { described_class.persist_all }

    let(:job_events) { base_job_events }
    let(:job_id) { create(:job).id }

    before do
      job_events.each do |event|
        event.save!
      end
    end

    it "persists the freshness" do
      expect { subject }.to change { JobFreshness.count }.by(1)
    end
  end

  describe "#get" do
    subject { described_class.new(job_events, now: now).get }

    let(:job_events) { base_job_events }

    it "returns 'fresh'" do
      expect(subject).to eq(JobFreshnessService::FreshnessContext.new(
        job_id: job_id,
        status: "fresh",
        applicants: {},
        employment_title: "Welder",
        hidden: false,
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
            hide_job: true,
          },
          occurred_at: job_created_at + 1.day
        )
      end

      it "returns 'stale'" do
        expect(subject).to eq(JobFreshnessService::FreshnessContext.new(
          job_id: job_id,
          status: "stale",
          applicants: {},
          hidden: true,
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
          ))
        end
      end
    end
  end
end
