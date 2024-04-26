require 'rails_helper'
require 'swagger_helper'

RSpec.describe "Admin::Jobs", type: :request do
  describe "GET /index" do
    subject { get admin_jobs_path, headers: }

    it_behaves_like "admin secured endpoint"
  end

  path '/admin/jobs/{id}' do
    get "Show a job" do
      tags 'Admin'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string
      security [bearer_auth: []]

      include_context "olive branch casing parameter"
      include_context "olive branch camelcasing"

      let(:job) { create(:job) }
      let(:id) { job.id }

      context "when authenticated" do
        include_context "admin authenticated openapi"

        response '200', 'Retreives a job' do
          schema '$ref' => '#/components/schemas/admin_job'

          context "when job is fully loaded" do
            before do
              create(:job_attribute, job:)
              create(:career_path, job:)
              create(:learned_skill, job:)
              create(:desired_skill, job:)
              create(:desired_certification, job:)
              create(:job_photo, job:)
              create(:testimonial, job:)
              create(:job_tag, job:)
            end

            let(:job) { create(:job) }
            let(:id) { job.id }

            run_test!
          end
        end
      end
    end
  end

  describe "POST /create" do
    subject { post admin_jobs_path, params:, headers: }

    let(:params) do
      {
        job: {
          category: Job::Categories::STAFFING,
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
          category: Job::Categories::STAFFING,
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
    subject { put admin_job_path(job), params:, headers: }

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
