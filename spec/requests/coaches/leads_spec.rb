require 'rails_helper'
require 'swagger_helper'

RSpec.describe "Leads", type: :request do
  path "/coaches/leads" do
    get "Retrieve all leads" do
      tags 'Coaches'
      produces 'application/json'
      security [bearer_auth: []]

      include_context "olive branch casing parameter"
      include_context "olive branch camelcasing"

      it_behaves_like "coach spec unauthenticated openapi"

      context "when authenticated" do
        include_context "coach authenticated openapi"

        response '200', 'retrieve all seekers' do
          schema type: :array,
                 items: {
                   '$ref' => '#/components/schemas/lead'
                 }

          context "when are no seekers" do
            run_test!
          end

          context "when there are many leads" do
            before do
              create(:coaches__coach_seeker_context, :lead)
              create(:coaches__coach_seeker_context, :lead)
            end

            run_test!
          end
        end
      end
    end
  end

  path "/coaches/leads" do
    post "Create new lead" do
      tags 'Coaches'
      consumes 'application/json'
      security [bearer_auth: []]
      parameter name: :lead_params, in: :body, schema: {
        type: :object,
        properties: {
          lead: {
            type: :object,
            properties: {
              leadId: {
                type: :string,
                format: :uuid
              },
              email: {
                type: :string,
                format: :email
              },
              phoneNumber: {
                type: :string
              },
              firstName: {
                type: :string
              },
              lastName: {
                type: :string
              }
            }
          }
        },
        required: %w[email phoneNumber firstName lastName]
      }

      include_context "olive branch casing parameter"
      include_context "olive branch camelcasing"

      it_behaves_like "coach spec unauthenticated openapi"

      let(:coach_seeker_context) { create(:coaches__coach_seeker_context) }
      let(:id) { coach_seeker_context.context_id }
      let(:lead_params) do
        {
          lead: {
            email: "john.chabot@blocktrainapp.com",
            phone_number: "333-333-3333",
            first_name: "john",
            last_name: "Chabot",
            lead_id: "eaa9b128-4285-4ae9-abb1-9fd548a5b9d5"
          }
        }
      end

      context "when authenticated" do
        include_context "coach authenticated openapi"

        response '201', 'lead created' do
          before do
            expect_any_instance_of(Coaches::SeekerReactor)
              .to receive(:add_lead)
              .with(
                lead_captured_by: coach.email,
                email: "john.chabot@blocktrainapp.com",
                phone_number: "333-333-3333",
                first_name: "john",
                last_name: "Chabot",
                lead_id: "eaa9b128-4285-4ae9-abb1-9fd548a5b9d5",
                trace_id: be_a(String)
              )
              .and_call_original
          end

          run_test!
        end
      end
    end
  end
end
