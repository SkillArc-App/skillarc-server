require 'rails_helper'

RSpec.describe "JobPhotos", type: :request do
  include_context "admin authenticated"

  let(:job) { create(:job) }

  describe "POST /create" do
    subject { post job_job_photos_path(job), params: params, headers: headers }

    let(:params) do
      {
        job_photo: {
          photo_url: "https://www.google.com",
        },
      }
    end

    it "returns 200" do
      subject

      expect(response).to have_http_status(200)
    end

    it "creates a job photo" do
      expect { subject }.to change { JobPhoto.count }.by(1)
    end
  end

  describe "DELETE /destroy" do
    subject { delete job_job_photo_path(job, job_photo), headers: headers }

    let!(:job_photo) { create(:job_photo, job: job) }

    it "returns 200" do
      subject

      expect(response).to have_http_status(200)
    end

    it "deletes the job photo" do
      expect { subject }.to change { JobPhoto.count }.by(-1)
    end
  end
end
