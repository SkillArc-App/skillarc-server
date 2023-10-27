require 'rails_helper'

RSpec.describe "Jobs", type: :request do
  describe "GET /index" do
    subject { get jobs_path }

    it_behaves_like "admin secured endpoint"
  end

  describe "GET /show" do
    subject { get job_path(job) }

    let(:job) { create(:job) }

    it "returns a 200" do
      subject

      expect(response).to have_http_status(200)
    end
  end

  describe "POST /apply" do
    include_context "authenticated"

    subject { post job_apply_path(job) }

    let(:job) { create(:job) }
    let!(:profile) { create(:profile, user: user) }

    it "returns a 200" do
      subject

      expect(response).to have_http_status(200)
    end

    it "creates an applicant" do
      expect { subject }.to change { Applicant.count }.by(1)
    end
  end

  describe "POST /create" do
    subject { post jobs_path, params: params }

    include_context "admin authenticated"

    let(:params) do
      {
        job: {
          employment_title: "Laborer",
          employer_id: employer.id,
          location: "Columbus, OH",
          benefits_description: "Benefits",
          responsibilities_description: "Responsibilities",
          employment_type: "FULLTIME",
          schedule: "9-5",
          work_days: "M-F",
          requirements_description: "Requirements",
          industry: ["MANUFACTURING"]
        }
      }
    end
    let(:employer) { create(:employer) }

    it "returns a 200" do
      subject

      expect(response).to have_http_status(200)
    end

    it "creates a job" do
      expect { subject }.to change { Job.count }.by(1)
    end
  end

  describe "PUT /update" do
    subject { put job_path(job), params: params }

    include_context "admin authenticated"

    let(:job) { create(:job) }

    let(:params) do
      {
        job: {
          employment_title: "New Laborer",
        }
      }
    end

    it "returns a 200" do
      subject 

      expect(response).to have_http_status(200)
    end

    it "updates the job" do
      subject

      expect(job.reload.employment_title).to eq("New Laborer")
    end
  end
end
