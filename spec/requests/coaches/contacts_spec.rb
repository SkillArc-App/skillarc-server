require 'rails_helper'
require 'swagger_helper'

RSpec.describe "Coaches::Contexts", type: :request do
  path '/coaches/contexts/{id}/contacts' do
    post "Create a contact" do
      tags 'Coaches'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string,
                format: :uuid
      parameter name: :contact_params, in: :body, schema: {
        type: :object,
        properties: {
          job: {
            type: :object,
            properties: {
              note: {
                type: :string
              },
              contactDirection: {
                type: :string,
                enum: Contact::ContactDirection::ALL
              },
              contactType: {
                type: :string,
                enum: Contact::ContactType::ALL
              }
            }
          }
        },
        required: %w[personId note contactDirection contactType]
      }
      security [bearer_auth: []]

      include_context "olive branch casing parameter"
      include_context "olive branch camelcasing"

      it_behaves_like "coach spec unauthenticated openapi"

      let(:id) { SecureRandom.uuid }
      let(:contact_params) do
        {
          note: "Called them",
          contactType: Contact::ContactType::PHONE,
          contactDirection: Contact::ContactDirection::SENT
        }
      end

      context "when authenticated" do
        include_context "coach authenticated openapi"

        response '201', 'tracks communication' do
          before do
            expect_any_instance_of(MessageService)
              .to receive(:create!)
              .with(
                trace_id: be_a(String),
                schema: Users::Commands::Contact::V1,
                user_id: user.id,
                data: {
                  person_id: id,
                  note: contact_params[:note],
                  contact_direction: contact_params[:contactDirection],
                  contact_type: contact_params[:contactType]
                }
              )
              .and_call_original
          end

          run_test!
        end
      end
    end
  end
end
