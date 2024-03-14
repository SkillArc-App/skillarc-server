require "rails_helper"

RSpec.describe Coaches::JobService do
  let(:job_created) do
    build(
      :message,
      :job_created,
      aggregate_id: job_id,
      version: 3,
      data: Events::JobCreated::Data::V3.new(
        category: Job::Categories::MARKETPLACE,
        employment_title: "Laborer",
        employer_name: "Employer",
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
  let(:job_created2) do
    build(
      :message,
      :job_created,
      aggregate_id: other_job_id,
      version: 3,
      data: Events::JobCreated::Data::V3.new(
        category: Job::Categories::MARKETPLACE,
        employment_title: "Other Laborer",
        employer_name: "Employer",
        employer_id:,
        benefits_description: "Benefits",
        responsibilities_description: "Responsibilities",
        location: "Columbus, OH",
        employment_type: "FULLTIME",
        hide_job: true,
        schedule: "9-5",
        work_days: "M-F",
        requirements_description: "Requirements",
        industry: [Job::Industries::MANUFACTURING]
      )
    )
  end
  let(:job_id) { SecureRandom.uuid }
  let(:other_job_id) { SecureRandom.uuid }
  let(:employer_id) { SecureRandom.uuid }
  let(:consumer) { described_class.new }

  before do
    consumer.handle_message(job_created)
    consumer.handle_message(job_created2)
  end

  it_behaves_like "a message consuemr"

  describe ".all" do
    subject { consumer.all }

    it "returns all unhidden jobs" do
      expect(subject).to eq(
        [{
          id: job_id,
          employer_name: "Employer",
          employment_title: "Laborer"
        }]
      )
    end
  end

  describe ".reset_for_replay" do
    it "destroys all records" do
      expect(Coaches::Job.count).not_to eq(0)

      consumer.reset_for_replay

      expect(Coaches::Job.count).to eq(0)
    end
  end
end
