require 'rails_helper'

RSpec.describe "CareerPaths", type: :request do
  include_context "admin authenticated"

  describe "POST /create" do
    subject { post job_career_paths_path(job), params:, headers: }

    let(:job) { create(:job) }
    let(:params) do
      {
        career_path: {
          title: "Level 1",
          lower_limit: "10",
          upper_limit: "15"
        }
      }
    end

    it "returns 200" do
      subject

      expect(response).to have_http_status(:ok)
    end

    it "creates a career path" do
      expect { subject }.to change { job.career_paths.count }.by(1)
    end
  end

  describe "POST /up" do
    subject { put job_career_path_up_path(job, path), headers: }

    let(:job) { create(:job) }
    let!(:path) { create(:career_path, job:, order: 1) }
    let!(:path_above) { create(:career_path, job:, order: 0) }

    it "returns 200" do
      subject

      expect(response).to have_http_status(:ok)
    end

    it "updates the order of the paths" do
      expect { subject }
        .to change { path.reload.order }.to(0)
        .and change { path_above.reload.order }.to(1)
    end
  end

  describe "POST /down" do
    subject { put job_career_path_down_path(job, path), headers: }

    let(:job) { create(:job) }
    let!(:path) { create(:career_path, job:, order: 0) }
    let!(:path_below) { create(:career_path, job:, order: 1) }

    it "returns 200" do
      subject

      expect(response).to have_http_status(:ok)
    end

    it "updates the order of the paths" do
      expect { subject }
        .to change { path.reload.order }.to(1)
        .and change { path_below.reload.order }.to(0)
    end
  end

  describe "DELETE /destroy" do
    subject { delete job_career_path_path(job, path), headers: }

    let(:job) { create(:job) }
    let!(:path) { create(:career_path, job:, order: 0) }

    it "returns 200" do
      subject

      expect(response).to have_http_status(:ok)
    end

    it "deletes the path" do
      expect { subject }.to change { job.career_paths.count }.by(-1)
    end
  end
end
