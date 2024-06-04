require 'rails_helper'
require 'swagger_helper'

RSpec.describe "Coaches::JobOrders", type: :request do
  path '/coaches/job_orders' do
    get 'Retrieves all job orders' do
      tags 'Coaches'
      security [bearer_auth: []]

      include_context "olive branch casing parameter"
      include_context "olive branch camelcasing"

      it_behaves_like "coach spec unauthenticated openapi"

      context "when authenticated" do
        include_context "coach authenticated openapi"

        response '200', 'retrieves job seekers' do
          before do
            expect(JobOrders::JobOrdersQuery)
              .to receive(:all_orders)
              .and_call_original
          end

          run_test!
        end
      end
    end
  end

  path '/coaches/job_orders/{id}/recommend' do
    post 'Recommends a job order to a seeker' do
      tags 'Coaches'
      consumes 'application/json'

      parameter name: :id, in: :path, type: :string
      parameter name: :recommend_params, in: :body, schema: {
        type: :object,
        properties: {
          seeker_id: { type: :string }
        },
        required: ['seeker_id']
      }
      security [bearer_auth: []]

      let(:recommend_params) do
        {
          seeker_id:
        }
      end

      include_context "olive branch casing parameter"
      include_context "olive branch camelcasing"

      it_behaves_like "coach spec unauthenticated openapi"

      let(:job_order) { create(:job_orders__job_order) }
      let(:id) { job_order.id }
      let(:seeker_id) { create(:job_orders__seeker).id }

      context "when authenticated" do
        include_context "coach authenticated openapi"

        response '202', 'recommends a job order' do
          before do
            expect_any_instance_of(Coaches::CoachesEventEmitter)
              .to receive(:recommend_for_job_order)
              .with(
                job_order_id: job_order.id,
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
