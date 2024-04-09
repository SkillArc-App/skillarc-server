require 'rails_helper'

RSpec.describe Jobs::JobPhotosService do
  describe ".create" do
    subject { described_class.create(job, photo_url) }

    include_context "event emitter"

    let(:job) { create(:job) }
    let(:photo_url) { "https://example.com/photo.jpg" }

    it "creates a job photo" do
      expect { subject }.to change(JobPhoto, :count).by(1)

      job_photo = JobPhoto.last

      expect(job_photo.job_id).to eq(job.id)
      expect(job_photo.photo_url).to eq(photo_url)
    end

    it "publishes an event" do
      expect_any_instance_of(MessageService).to receive(:create!).with(
        schema: Events::JobPhotoCreated::V1,
        job_id: be_present,
        data: {
          id: be_a(String),
          job_id: job.id,
          photo_url:
        }
      ).and_call_original

      subject
    end
  end

  describe ".destroy" do
    subject { described_class.destroy(job_photo) }

    include_context "event emitter"

    let!(:job_photo) { create(:job_photo) }

    it "destroys the job photo" do
      expect { subject }.to change(JobPhoto, :count).by(-1)
    end

    it "publishes an event" do
      expect_any_instance_of(MessageService).to receive(:create!).with(
        schema: Events::JobPhotoDestroyed::V1,
        job_id: job_photo.job_id,
        data: {
          id: job_photo.id
        }
      ).and_call_original

      subject
    end
  end
end
