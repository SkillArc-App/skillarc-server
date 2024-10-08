require 'rails_helper'
require 'swagger_helper'

RSpec.describe "Attributes", type: :request do
  path '/admin/attributes' do
    post "create an attribute" do
      tags 'Admin'
      produces 'application/json'
      consumes 'application/json'
      security [bearer_auth: []]

      include_context "olive branch casing parameter"
      include_context "olive branch camelcasing"

      it_behaves_like "admin spec unauthenticated openapi"

      let(:attribute) do
        {
          name: "name",
          description: "description",
          set: %w[A B],
          default: ["B"]
        }
      end

      context "when authenticated" do
        include_context "admin authenticated openapi"

        parameter name: :attribute, in: :body, schema: {
          type: :object,
          properties: {
            name: { type: :string },
            description: { type: :string },
            set: { type: :array, items: { type: :string } },
            default: { type: :array, items: { type: :string } }
          },
          required: %w[name set default]
        }

        response '201', 'Creates an attribute' do
          before do
            expect_any_instance_of(MessageService)
              .to receive(:create!)
              .with(
                schema: Attributes::Commands::Create::V1,
                trace_id: be_a(String),
                attribute_id: be_a(String),
                data: {
                  machine_derived: false,
                  name: "name",
                  description: "description",
                  set: %w[A B],
                  default: ["B"]
                },
                metadata: {
                  requestor_id: user.id,
                  requestor_type: Requestor::Kinds::USER
                }
              )
              .and_call_original
          end

          run_test!
        end
      end
    end
  end

  path '/admin/attributes/{id}' do
    put "update an attribute" do
      tags 'Admin'
      produces 'application/json'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter name: :attribute, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          description: { type: :string },
          set: { type: :array, items: { type: :string } },
          default: { type: :array, items: { type: :string } }
        }
      }
      security [bearer_auth: []]

      include_context "olive branch casing parameter"
      include_context "olive branch camelcasing"

      before do
        Event.from_message!(
          build(
            :message,
            schema: Attributes::Events::Created::V4,
            stream: Attributes::Streams::Attribute.new(attribute_id: id)
          )
        )
      end

      let(:id) { SecureRandom.uuid }
      let(:attribute) do
        {
          name: "new name",
          description: "new description",
          set: %w[C D],
          default: ["D"]
        }
      end

      it_behaves_like "admin spec unauthenticated openapi"

      context "when authenticated" do
        include_context "admin authenticated openapi"

        response '204', 'Updates an attribute' do
          before do
            expect_any_instance_of(MessageService)
              .to receive(:create!)
              .with(
                schema: Attributes::Commands::Create::V1,
                trace_id: be_a(String),
                attribute_id: id,
                data: {
                  machine_derived: false,
                  name: "new name",
                  description: "new description",
                  set: %w[C D],
                  default: ["D"]
                },
                metadata: {
                  requestor_id: user.id,
                  requestor_type: Requestor::Kinds::USER
                }
              )
              .and_call_original
          end

          run_test!
        end
      end
    end

    delete "delete an attribute" do
      tags 'Admin'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string
      security [bearer_auth: []]

      include_context "olive branch casing parameter"
      include_context "olive branch camelcasing"

      let(:id) { create(:attributes_attribute).id }

      it_behaves_like "admin spec unauthenticated openapi"

      context "when authenticated" do
        include_context "admin authenticated openapi"

        response '204', 'Deletes an attribute' do
          before do
            expect_any_instance_of(MessageService)
              .to receive(:create!)
              .with(
                schema: Attributes::Commands::Delete::V1,
                trace_id: be_a(String),
                attribute_id: id,
                data: Core::Nothing,
                metadata: {
                  requestor_id: user.id,
                  requestor_type: Requestor::Kinds::USER
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
