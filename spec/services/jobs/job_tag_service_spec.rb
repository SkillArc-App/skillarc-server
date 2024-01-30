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
        aggregate_id: be_present,
        data: Events::Common::UntypedHashWrapper.build(
          job_id: job.id,
          tag_id: tag.id
        ),
        occurred_at: be_present
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
        event_schema: Events::JobTagDestroyed::V1,
        aggregate_id: job_tag.job_id,
        data: Events::Common::UntypedHashWrapper.build(
          job_id: job_tag.job_id,
          tag_id: job_tag.tag_id
        ),
        occurred_at: be_present
      ).and_call_original

      subject
    end
  end
end
