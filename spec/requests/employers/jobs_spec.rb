require 'rails_helper'
require 'swagger_helper'

RSpec.describe "Employers::Jobs", type: :request do
  path '/employers/jobs' do
    context "when authenticated" do
      include_context "employer authenticated"

      it "calls Employers::JobService" do
        expect(Employers::JobService)
          .to receive(:new)
          .with(employers: [employer])
          .and_call_original

        expect_any_instance_of(Employers::JobService)
          .to receive(:all)
          .and_call_original

        get employers_jobs_path, headers:
      end

      it "calls Employers::ApplicantService" do
        expect(Employers::ApplicantService)
          .to receive(:new)
          .with(employers: [employer])
          .and_call_original

        expect_any_instance_of(Employers::ApplicantService)
          .to receive(:all)
          .and_call_original

        get employers_jobs_path, headers:
      end
    end

    get "Retrieve employer jobs" do
      tags 'Employers'
      produces 'application/json'
      security [bearer_auth: []]

      include_context "olive branch casing parameter"
      include_context "olive branch camelcasing"

      it_behaves_like "employer spec unauthenticated openapi"

      context "when authenticated" do
        before do
          job1 = create(:job, employer:)
          job2 = create(:job, employer:)

          create(:applicant, job: job1)
          create(:applicant, job: job2)
          create(:applicant, job: job2)
        end

        include_context "employer authenticated openapi"

        response '200', 'jobs retrieved' do
          schema type: :object,
                 properties: {
                   jobs: {
                     type: :array,
                     items: {
                       type: :object,
                       properties: {
                         id: {
                           type: :string,
                           format: :uuid
                         },
                         employerId: {
                           type: :string,
                           format: :uuid
                         },
                         employerName: {
                           type: :string
                         },
                         name: {
                           type: :string
                         },
                         description: {
                           type: :string
                         }
                       }

                     }
                   },
                   applicants: {
                     type: :array,
                     items: {
                       '$ref' => '#/components/schemas/employer_applicants'
                     }
                   }
                 },
                 required: %w[jobs applicants]

          run_test!
        end
      end
    end
  end
end
