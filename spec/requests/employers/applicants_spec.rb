require 'rails_helper'
require 'swagger_helper'

RSpec.describe "Employers::Applicants", type: :request do
  path '/employers/applicants/{id}' do
    put "Update an applicants status" do
      tags 'Employers'
      consumes 'application/json'
      produces 'application/json'
      security [bearer_auth: []]
      parameter name: :id, in: :path, type: :string
      parameter name: :update, in: :body, schema: {
        type: :object,
        properties: {
          status: {
            type: :string,
            enum: ApplicantStatus::StatusTypes::ALL
          },
          reasons: {
            nullable: true,
            type: :array,
            items: {
              oneOf: [
                {
                  type: :string
                },
                {
                  type: :object,
                  properties: {
                    id: {
                      type: :string,
                      format: :uuid
                    },
                    response: {
                      type: :string,
                      format: :uuid
                    }
                  }
                }
              ]
            }
          }
        },
        required: %w[status]
      }

      let(:applicant) { create(:applicant) }
      let(:id) { applicant.id }
      let(:status) { ApplicantStatus::StatusTypes::PENDING_INTRO }
      let(:reasons) { [{ id: create(:reason).id, response: "Bad canidate" }] }
      let(:update) do
        {
          status:,
          reasons:
        }
      end

      include_context "olive branch casing parameter"
      include_context "olive branch camelcasing"

      it_behaves_like "employer spec unauthenticated openapi"

      context "when authenticated" do
        include_context "employer authenticated openapi"

        response '200', 'Applicant updated' do
          schema '$ref' => '#/components/schemas/applicant'

          context "when reasons are given" do
            let(:reasons) { nil }

            before do
              expect_any_instance_of(ApplicantService)
                .to receive(:update_status)
                .with(status:, user_id: user.id, reasons: [])
            end

            run_test!
          end

          context "when reasons are not given" do
            let(:reasons) { [{ id: create(:reason).id, response: "Bad canidate" }] }

            before do
              expect_any_instance_of(ApplicantService)
                .to receive(:update_status)
                .with(status:, user_id: user.id, reasons:)
            end

            run_test!
          end
        end
      end
    end
  end
end
