require 'rails_helper'
require 'swagger_helper'

RSpec.describe "OnboardingSessions", type: :request do
  path "/onboarding_sessions" do
    post "Create new onboarding session" do
      tags "Seekers"
      security [bearer_auth: []]
      produces 'application/json'
      security [bearer_auth: []]

      include_context "olive branch casing parameter"
      include_context "olive branch camelcasing"

      it_behaves_like "spec unauthenticated openapi"

      context "when authenticated" do
        include_context "authenticated openapi"

        response '200', 'Create an experience' do
          schema '$ref' => '#/components/schemas/onboarding_session'

          context "when there is already a seeker" do
            before do
              create(:seeker, user:)
            end

            run_test!
          end

          context "when there is not a seeker" do
            run_test!
          end
        end
      end
    end

    put "Update a onboarding session" do
      tags "Seekers"
      security [bearer_auth: []]
      consumes 'application/json'
      produces 'application/json'
      parameter name: :onboarding_params, in: :body, schema: {
        type: :object,
        properties: {
          onboarding_session: {
            type: :object
          }
        },
        required: %w[onboarding_session]
      }
      security [bearer_auth: []]

      include_context "olive branch casing parameter"
      include_context "olive branch camelcasing"

      it_behaves_like "spec unauthenticated openapi"

      let(:onboarding_params) do
        {
          onboarding_session: {
            responses: {
              name: {
                response: {
                  firstName: "Hannah",
                  lastName: "Montana",
                  phoneNumber: "1234567890",
                  dateOfBirth: "01/01/2000"
                }
              }
            }
          }
        }
      end

      context "when authenticated" do
        include_context "authenticated openapi"

        response '400', 'Bad request no seeker' do
          schema schema: {
            type: :object,
            properties: {
              error: {
                type: :string
              }
            }
          }

          run_test!
        end

        response '200', 'Create an experience' do
          schema '$ref' => '#/components/schemas/onboarding_session'

          let!(:seeker) { create(:seeker, user:) }

          run_test!
        end
      end
    end
  end
end
