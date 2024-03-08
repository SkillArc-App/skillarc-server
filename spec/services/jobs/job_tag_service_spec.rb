require 'rails_helper'

RSpec.describe Jobs::JobTagService do
  describe ".create" do
    subject { described_class.create(job, tag) }

    let(:job) { create(:job) }
    let!(:tag) { create(:tag) }

    it "creates a job tag" do
      expect { subject }.to change(JobTag, :count).by(1)

      job_tag = JobTag.last

      expect(job_tag.job_id).to eq(job.id)
      expect(job_tag.tag_id).to eq(tag.id)
    end

    it "publishes an event" do
      expect(EventService).to receive(:create!).with(
        event_schema: Events::JobTagCreated::V1,
        job_id: be_present,
        data: Events::JobTagCreated::Data::V1.new(
          job_id: job.id,
          tag_id: tag.id
        )
      ).and_call_original

      subject
    end
  end

  describe ".destroy" do
    subject { described_class.destroy(job_tag) }

    let!(:job_tag) { create(:job_tag) }

    it "destroys the job tag" do
      expect { subject }.to change(JobTag, :count).by(-1)
    end

    it "publishes an event" do
      expect(EventService).to receive(:create!).with(
        event_schema: Events::JobTagDestroyed::V2,
        job_id: job_tag.job_id,
        data: Events::JobTagDestroyed::Data::V2.new(
          tag_id: job_tag.tag_id,
          job_tag_id: job_tag.id,
          job_id: job_tag.job_id
        )
      ).and_call_original

      subject
    end
  end
end
