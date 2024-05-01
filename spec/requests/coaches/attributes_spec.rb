require 'rails_helper'
require 'swagger_helper'

RSpec.describe "Notes", type: :request do
  path '/coaches/seekers/{seeker_id}/attributes' do
    post "Add an attribute" do
      tags 'Coaches'
      consumes 'application/json'
      parameter name: :seeker_id, in: :path, type: :string
      parameter name: :attribute_params, in: :body, schema: {
        type: :object,
        properties: {
          attributeId: {
            type: :string,
            format: :uuid
          },
          name: {
            type: :string
          },
          value: {
            type: :string
          }
        },
        required: %w[attributesId name value]
      }
      security [bearer_auth: []]

      include_context "olive branch casing parameter"
      include_context "olive branch camelcasing"

      it_behaves_like "coach spec unauthenticated openapi"

      let!(:coach_seeker_context) { create(:coaches__coach_seeker_context, seeker_id:) }
      let(:seeker_id) { SecureRandom.uuid }
      let(:attribute_params) do
        {
          attributeId: attribute_id,
          name:,
          value:
        }
      end
      let(:attribute_id) { SecureRandom.uuid }
      let(:name) { "A name" }
      let(:value) { "A value" }

      context "when authenticated" do
        include_context "coach authenticated openapi"

        response '201', 'Adds an attribute' do
          before do
            expect_any_instance_of(Coaches::CoachesReactor)
              .to receive(:add_attribute)
              .with(
                seeker_attribute_id: be_a(String),
                seeker_id:,
                attribute_id:,
                attribute_name: name,
                attribute_value: value,
                trace_id: be_a(String)
              )
              .and_call_original
          end

          run_test!
        end
      end
    end
  end

  path '/coaches/seekers/{seeker_id}/attributes/{id}' do
    put "update an attribute" do
      tags 'Coaches'
      consumes 'application/json'
      parameter name: :seeker_id, in: :path, type: :string
      parameter name: :id, in: :path, type: :string
      parameter name: :attribute_params, in: :body, schema: {
        type: :object,
        properties: {
          attributeId: {
            type: :string,
            format: :uuid
          },
          name: {
            type: :string
          },
          value: {
            type: :string
          }
        },
        required: %w[attributesId name value]
      }
      security [bearer_auth: []]

      include_context "olive branch casing parameter"
      include_context "olive branch camelcasing"

      it_behaves_like "coach spec unauthenticated openapi"

      let(:coach_seeker_context) { create(:coaches__coach_seeker_context, seeker_id: SecureRandom.uuid) }
      let(:seeker_id) { coach_seeker_context.seeker_id }
      let(:id) { seeker_attribute.id }
      let(:seeker_attribute) { create(:coaches__seeker_attribute) }
      let(:attribute_params) do
        {
          attributeId: attribute_id,
          name:,
          value:
        }
      end
      let(:attribute_id) { SecureRandom.uuid }
      let(:name) { "A name" }
      let(:value) { "A value" }

      context "when authenticated" do
        include_context "coach authenticated openapi"

        response '202', 'Adds an attribute' do
          before do
            expect_any_instance_of(Coaches::CoachesReactor)
              .to receive(:add_attribute)
              .with(
                seeker_attribute_id: id,
                seeker_id:,
                attribute_id:,
                attribute_name: name,
                attribute_value: value,
                trace_id: be_a(String)
              )
              .and_call_original
          end

          run_test!
        end
      end
    end

    delete "remove an attribute" do
      tags 'Coaches'
      parameter name: :seeker_id, in: :path, type: :string
      parameter name: :id, in: :path, type: :string
      security [bearer_auth: []]

      include_context "olive branch casing parameter"
      include_context "olive branch camelcasing"

      it_behaves_like "coach spec unauthenticated openapi"

      let(:coach_seeker_context) { create(:coaches__coach_seeker_context, seeker_id: SecureRandom.uuid) }
      let(:seeker_id) { coach_seeker_context.seeker_id }
      let(:id) { seeker_attribute.id }
      let(:seeker_attribute) { create(:coaches__seeker_attribute) }

      context "when authenticated" do
        include_context "coach authenticated openapi"

        response '202', 'Removes an attribute' do
          before do
            expect_any_instance_of(Coaches::CoachesReactor)
              .to receive(:remove_attribute)
              .with(
                seeker_attribute_id: id,
                seeker_id:,
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
