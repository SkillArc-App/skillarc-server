require 'rails_helper'

RSpec.describe Jobs::JobService do
  describe "#create" do
    subject { described_class.new.create(params) }

    let(:params) do
      {
        employment_title:,
        employer_id:,
        benefits_description:,
        responsibilities_description:,
        location:,
        employment_type:,
        hide_job:,
        schedule:,
        work_days:,
        requirements_description:,
        industry:
      }
    end
    let(:employment_title) { "Laborer" }
    let(:employer_id) { create(:employer).id }
    let(:benefits_description) { "Benefits" }
    let(:responsibilities_description) { "Responsibilities" }
    let(:employment_title) { "Laborer" }
    let(:location) { "Columbus, OH" }
    let(:employment_type) { "FULLTIME" }
    let(:hide_job) { false }
    let(:schedule) { "9-5" }
    let(:work_days) { "M-F" }
    let(:requirements_description) { "Requirements" }
    let(:industry) { ["manufacturing"] }

    it "creates a job" do
      expect { subject }.to change(Job, :count).by(1)

      job = Job.last

      expect(job.employment_title).to eq(employment_title)
      expect(job.employer_id).to eq(employer_id)
      expect(job.benefits_description).to eq(benefits_description)
      expect(job.responsibilities_description).to eq(responsibilities_description)
      expect(job.employment_title).to eq(employment_title)
      expect(job.location).to eq(location)
      expect(job.employment_type).to eq(employment_type)
      expect(job.hide_job).to eq(hide_job)
      expect(job.schedule).to eq(schedule)
      expect(job.work_days).to eq(work_days)
      expect(job.requirements_description).to eq(requirements_description)
      expect(job.industry).to eq(industry)
    end

    it "publishes an event" do
      expect(EventService).to receive(:create!).with(
        event_schema: Events::JobCreated::V1,
        aggregate_id: be_present,
        data: Events::JobCreated::Data::V1.new(
          employment_title:,
          employer_id:,
          benefits_description:,
          responsibilities_description:,
          location:,
          employment_type:,
          hide_job:,
          schedule:,
          work_days:,
          requirements_description:,
          industry:
        ),
        occurred_at: be_present
      ).and_call_original

      subject
    end
  end

  describe "#update" do
    subject { described_class.new.update(job, params) }

    let(:job) { create(:job) }
    let(:params) do
      {
        employment_title:,
        benefits_description:,
        responsibilities_description:,
        location:,
        employment_type:,
        hide_job:,
        schedule:,
        work_days:,
        requirements_description:,
        industry:
      }
    end
    let(:employment_title) { "NEW Laborer" }
    let(:benefits_description) { "NEW Benefits" }
    let(:responsibilities_description) { "NEW Responsibilities" }
    let(:employment_title) { "NEW Employment Title" }
    let(:location) { "NEW Columbus, OH" }
    let(:employment_type) { Job::EmploymentTypes::PARTTIME }
    let(:hide_job) { true }
    let(:schedule) { "NEW 9-5" }
    let(:work_days) { "NEW M-F" }
    let(:requirements_description) { "NEW Requirements" }
    let(:industry) { [Job::Industries::HEALTHCARE] }

    it "updates the job" do
      subject

      job.reload

      expect(job.employment_title).to eq(employment_title)
      expect(job.benefits_description).to eq(benefits_description)
      expect(job.responsibilities_description).to eq(responsibilities_description)
      expect(job.employment_title).to eq(employment_title)
      expect(job.location).to eq(location)
      expect(job.employment_type).to eq(employment_type)
      expect(job.hide_job).to eq(hide_job)
      expect(job.schedule).to eq(schedule)
      expect(job.work_days).to eq(work_days)
      expect(job.requirements_description).to eq(requirements_description)
      expect(job.industry).to eq(industry)
    end

    it "publishes an event" do
      expect(EventService).to receive(:create!).with(
        event_schema: Events::JobUpdated::V1,
        aggregate_id: job.id,
        data: Events::Common::UntypedHashWrapper.build(
          employment_title:,
          benefits_description:,
          responsibilities_description:,
          location:,
          employment_type:,
          hide_job:,
          schedule:,
          work_days:,
          requirements_description:,
          industry:
        ),
        occurred_at: be_present
      ).and_call_original

      subject
    end
  end
end
