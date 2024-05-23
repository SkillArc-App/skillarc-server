require 'rails_helper'
require 'swagger_helper'

RSpec.describe "References", type: :request do
  path "/references/{id}" do
    get "Retrieve a reference" do
      tags "Training Providers"
      produces "application/json"
      parameter name: :id, in: :path, type: :string
      security [bearer_auth: []]

      include_context "olive branch casing parameter"
      include_context "olive branch camelcasing"

      let(:id) { create(:reference, author_profile: user.training_provider_profile).id }

      context "when authenticated" do
        include_context "training provider authenticated openapi"

        response "200", "Returns a list of references" do
          schema type: :object,
                 items: {
                   properties: {
                     id: { type: :string, format: :uuid },
                     reference_text: { type: :string },
                     seeker_id: { type: :string, format: :uuid },
                     author_profile_id: { type: :string, format: :uuid },
                     training_provider_id: { type: :string, format: :uuid }
                   }
                 }

          run_test!
        end
      end
    end

    put "Update a reference" do
      tags "Training Providers"
      produces "application/json"
      consumes "application/json"
      security [bearer_auth: []]

      include_context "olive branch casing parameter"
      include_context "olive branch camelcasing"

      parameter name: :id, in: :path, type: :string
      parameter name: :reference, in: :body, schema: {
        type: :object,
        properties: {
          reference_text: {
            type: :string
          }
        },
        required: %w[reference_text]
      }

      let(:id) { create(:reference, author_profile: user.training_provider_profile).id }
      let(:reference) { { reference_text: "This is a new reference" } }

      context "when authenticated" do
        include_context "training provider authenticated openapi"

        response "200", "Reference updated" do
          schema type: :object,
                 properties: {
                   id: { type: :string, format: :uuid },
                   referenceText: { type: :string },
                   seekerId: { type: :string, format: :uuid },
                   authorProfileId: { type: :string, format: :uuid },
                   trainingProviderId: { type: :string, format: :uuid },
                   createdAt: { type: :string, format: :datetime },
                   updatedAt: { type: :string, format: :datetime }
                 }

          run_test!
        end
      end
    end
  end

  path "/references" do
    post "Create a reference" do
      tags "Training Providers"
      produces "application/json"
      consumes "application/json"
      security [bearer_auth: []]

      include_context "olive branch casing parameter"
      include_context "olive branch camelcasing"

      parameter name: :reference, in: :body, schema: {
        type: :object,
        properties: {
          reference: {
            type: :string
          },
          seeker_profile_id: {
            type: :string,
            format: :uuid
          }
        },
        required: %w[reference seeker_profile_id]
      }

      let(:reference) { { reference: "This is a reference", seeker_profile_id: create(:seeker).id } }

      context "when authenticated" do
        include_context "training provider authenticated openapi"

        response "200", "Reference created" do
          schema type: :object,
                 properties: {
                   id: { type: :string, format: :uuid },
                   referenceText: { type: :string },
                   seekerId: { type: :string, format: :uuid },
                   authorProfileId: { type: :string, format: :uuid },
                   trainingProviderId: { type: :string, format: :uuid },
                   createdAt: { type: :string, format: :datetime },
                   updatedAt: { type: :string, format: :datetime }
                 }

          run_test!
        end
      end
    end
  end
end
