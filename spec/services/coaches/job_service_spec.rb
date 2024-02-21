require "rails_helper"

RSpec.describe Coaches::JobService do
  let(:job_created) do
    build(
      :message,
      :job_created,
      aggregate_id: job_id,
      data: Events::JobCreated::Data::V1.new(
        employment_title: "Laborer",
        employer_id:,
        benefits_description: "Benefits",
        responsibilities_description: "Responsibilities",
        location: "Columbus, OH",
        employment_type: "FULLTIME",
        hide_job: false,
        schedule: "9-5",
        work_days: "M-F",
        requirements_description: "Requirements",
        industry: [Job::Industries::MANUFACTURING]
      )
    )
  end
  let(:job_id) { SecureRandom.uuid }
  let(:employer_id) { SecureRandom.uuid }

  before do
    described_class.handle_event(job_created)
  end

  it_behaves_like "an event consumer"

  describe ".all" do
    subject { described_class.all }

    it "returns all jobs" do
      expect(subject).to eq(
        [{
          id: job_id,
          employment_title: "Laborer"
        }]
      )
    end
  end

  describe ".reset_for_replay" do
    it "destroys all records" do
      expect(Coaches::Job.count).not_to eq(0)

      described_class.reset_for_replay

      expect(Coaches::Job.count).to eq(0)
    end
  end
end
