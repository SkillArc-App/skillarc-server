require 'rails_helper'

RSpec.describe "Jobs", type: :request do
  describe "GET /index" do
    subject { get jobs_path, headers: }

    it_behaves_like "admin secured endpoint"
  end

  describe "GET /show" do
    subject { get job_path(job), headers: }

    let(:job) { create(:job) }

    it "returns a 200" do
      subject

      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /apply" do
    subject { post job_apply_path(job), headers: }

    include_context "authenticated"

    let(:job) { create(:job) }
    let!(:profile) { create(:profile, user:) }
    let!(:seeker) { create(:seeker, user:) }

    it "returns a 200" do
      subject

      expect(response).to have_http_status(:ok)
    end

    it "creates an applicant" do
      expect { subject }.to change(Applicant, :count).by(1)
    end
  end

  describe "POST /create" do
    subject { post jobs_path, params:, headers: }

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
          industry: [Job::Industries::MANUFACTURING]
        }
      }
    end
    let(:employer) { create(:employer) }

    it_behaves_like "admin secured endpoint"

    context "admin authenticated" do
      include_context "admin authenticated"

      it "calls the job service" do
        expect_any_instance_of(Jobs::JobService).to receive(:create).with(
          employment_title: "Laborer",
          employer_id: employer.id,
          location: "Columbus, OH",
          benefits_description: "Benefits",
          responsibilities_description: "Responsibilities",
          employment_type: "FULLTIME",
          schedule: "9-5",
          work_days: "M-F",
          requirements_description: "Requirements",
          industry: [Job::Industries::MANUFACTURING]
        ).and_call_original

        subject
      end
    end
  end

  describe "PUT /update" do
    subject { put job_path(job), params:, headers: }

    let(:job) { create(:job) }

    let(:params) do
      {
        job: {
          employment_title: "New Laborer"
        }
      }
    end

    it_behaves_like "admin secured endpoint"

    context "admin authenticated" do
      include_context "admin authenticated"

      it "calls the job service" do
        expect_any_instance_of(Jobs::JobService).to receive(:update)
          .and_call_original

        subject
      end
    end
  end
end
