require 'rails_helper'

RSpec.describe Jobs::JobPhotosService do
  describe ".create" do
    subject { described_class.create(job, photo_url) }

    let(:job) { create(:job) }
    let(:photo_url) { "https://example.com/photo.jpg" }

    it "creates a job photo" do
      expect { subject }.to change(JobPhoto, :count).by(1)

      job_photo = JobPhoto.last

      expect(job_photo.job_id).to eq(job.id)
      expect(job_photo.photo_url).to eq(photo_url)
    end

    it "publishes an event" do
      expect(Events::JobPhotoCreated::Data::V1).to receive(:new).with(
        id: be_a(String),
        job_id: job.id,
        photo_url:
      ).and_call_original

      expect(EventService).to receive(:create!).with(
        event_schema: Events::JobPhotoCreated::V1,
        aggregate_id: be_present,
        data: be_a(Events::JobPhotoCreated::Data::V1)
      ).and_call_original

      subject
    end
  end

  describe ".destroy" do
    subject { described_class.destroy(job_photo) }

    let!(:job_photo) { create(:job_photo) }

    it "destroys the job photo" do
      expect { subject }.to change(JobPhoto, :count).by(-1)
    end

    it "publishes an event" do
      expect(EventService).to receive(:create!).with(
        event_schema: Events::JobPhotoDestroyed::V1,
        aggregate_id: job_photo.job_id,
        data: Events::JobPhotoDestroyed::Data::V1.new(
          id: job_photo.id
        )
      ).and_call_original

      subject
    end
  end
end
