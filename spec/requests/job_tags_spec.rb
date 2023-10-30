require 'rails_helper'

RSpec.describe "JobTags", type: :request do
  describe "POST /create" do
    subject { post job_job_tags_path(job), params: params }

    include_context "admin authenticated"

    let(:params) do
      {
        tag: tag.name
      }
    end
    let(:tag) { create(:tag) }
    let(:job) { create(:job) }

    it "returns a 200" do
      subject

      expect(response).to have_http_status(200)
    end

    it "creates a job tag" do
      expect { subject }.to change { JobTag.count }.by(1)
    end
  end

  describe "DELETE /destroy" do
    subject { delete job_job_tag_path(job, job_tag) }

    include_context "admin authenticated"

    let(:job_tag) { create(:job_tag, job:) }
    let(:job) { create(:job) }

    it "returns a 200" do
      subject

      expect(response).to have_http_status(200)
    end

    it "deletes the job tag" do
      job_tag

      expect { subject }.to change { JobTag.count }.by(-1)
    end
  end
end
