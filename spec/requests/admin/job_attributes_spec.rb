require 'rails_helper'
require 'swagger_helper'

RSpec.describe "Admin::JobAttributes", type: :request do
  path '/admin/jobs/{id}/job_attributes' do
    post "Create a job attribute" do
      tags 'Admin'
      produces 'application/json'
      consumes 'application/json'
      security [bearer_auth: []]

      parameter name: :id, in: :path, type: :string
      parameter name: :job_attribute, in: :body, schema: {
        type: :object,
        properties: {
          properties: {
            attribute_id: {
              type: :string,
              format: :uuid
            },
            acceptible_set: {
              type: :array,
              items: {
                type: :string,
                format: :uuid
              }
            }
          }
        },
        required: %w[job_attribute]
      }

      let(:job) { create(:job) }
      let(:id) { job.id }

      include_context "olive branch casing parameter"
      include_context "olive branch camelcasing"

      context "when authenticated" do
        include_context "admin authenticated openapi"

        let(:job_attribute) do
          {
            attributeId: attribute.id,
            acceptibleSet: acceptible_set
          }
        end
        let(:acceptible_set) { [SecureRandom.uuid, SecureRandom.uuid] }
        let(:attribute) { create(:attributes_attribute, set: [SecureRandom.uuid]) }

        response '201', 'Creates a job attribute' do
          before do
            expect_any_instance_of(Jobs::JobsReactor)
              .to receive(:create_job_attribute)
              .with(
                job_id: job.id,
                attribute_id: attribute.id,
                acceptible_set:
              )
              .and_call_original
          end

          run_test!
        end
      end
    end
  end

  path '/admin/jobs/{id}/job_attributes/{job_attribute_id}' do
    put "Update a job attribute" do
      tags 'Admin'
      produces 'application/json'
      consumes 'application/json'
      security [bearer_auth: []]

      parameter name: :id, in: :path, type: :string
      parameter name: :job_attribute_id, in: :path, type: :string

      parameter name: :job_attribute, in: :body, schema: {
        type: :object,
        properties: {
          properties: {
            acceptible_set: {
              type: :array,
              items: {
                type: :string,
                format: :uuid
              }
            }
          }
        },
        required: %w[job_attribute]
      }

      let(:job) { create(:job) }
      let(:id) { job.id }
      let(:job_attribute_id) { create(:job_attribute).id }

      include_context "olive branch casing parameter"
      include_context "olive branch camelcasing"

      context "when authenticated" do
        include_context "admin authenticated openapi"

        let(:job_attribute) do
          {
            acceptibleSet: acceptible_set
          }
        end
        let(:acceptible_set) { [SecureRandom.uuid] }

        response '204', 'Updates a job attribute' do
          before do
            expect_any_instance_of(Jobs::JobsReactor)
              .to receive(:update_job_attribute)
              .with(
                job_id: id,
                job_attribute_id:,
                acceptible_set:
              )
              .and_call_original
          end

          run_test!
        end
      end
    end

    delete "Destroy a job attribute" do
      tags 'Admin'
      produces 'application/json'
      consumes 'application/json'
      security [bearer_auth: []]

      parameter name: :id, in: :path, type: :string
      parameter name: :job_attribute_id, in: :path, type: :string

      let(:job) { create(:job) }
      let(:id) { job.id }
      let(:job_attribute) { create(:job_attribute, job:) }
      let(:job_attribute_id) { job_attribute.id }

      include_context "olive branch casing parameter"
      include_context "olive branch camelcasing"

      context "when authenticated" do
        include_context "admin authenticated openapi"

        response '204', 'Destroys a job attribute' do
          before do
            expect_any_instance_of(Jobs::JobsReactor)
              .to receive(:destroy_job_attribute)
              .with(job_id: id, job_attribute_id: job_attribute.id)
              .and_call_original
          end

          run_test!
        end
      end
    end
  end
end
