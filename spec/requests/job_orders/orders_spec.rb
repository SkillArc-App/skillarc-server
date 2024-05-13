require 'rails_helper'
require 'swagger_helper'

RSpec.describe "JobOrders", type: :request do
  path '/job_orders/orders' do
    get "get all job orders" do
      tags 'Job Orders'
      produces 'application/json'
      security [bearer_auth: []]

      include_context "olive branch casing parameter"
      include_context "olive branch camelcasing"

      it_behaves_like "an unauthenticated user"

      context "when authenticated" do
        include_context "job order authenticated"

        response '200', 'Returns all job orders' do
          schema type: :array,
                 items: {
                   '$ref' => '#/components/schemas/job_order_summary'
                 }

          before do
            job_order1 = create(:job_orders__job_order)
            job_order2 = create(:job_orders__job_order)

            create(:job_orders__candidate, job_order: job_order1)
            create(:job_orders__candidate, job_order: job_order1)
            create(:job_orders__application, job: job_order1.job)

            create(:job_orders__candidate, job_order: job_order2)
            create(:job_orders__application, job: job_order2.job)
          end

          let(:context_id) { reminder_context_id }

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

  path '/job_orders/orders/{id}' do
    get "get a job order" do
      tags 'Job Orders'
      produces 'application/json'
      security [bearer_auth: []]
      parameter name: 'id',
                in: :path,
                type: :string,
                format: :uuid

      include_context "olive branch casing parameter"
      include_context "olive branch camelcasing"

      let(:id) { SecureRandom.uuid }

      it_behaves_like "an unauthenticated user"

      context "when authenticated" do
        include_context "job order authenticated"

        response '404', 'Coach not found' do
          let(:job_order_id) { SecureRandom.uuid }

          run_test!
        end

        response '200', 'Returns all job orders' do
          schema '$ref' => '#/components/schemas/job_order'

          let(:job_order) { create(:job_orders__job_order) }
          let!(:candidate) { create(:job_orders__candidate, job_order:) }
          let!(:application) { create(:job_orders__application, job: job_order.job) }

          let(:id) { job_order.id }

          before do
            expect(JobOrders::JobOrdersQuery)
              .to receive(:find_order)
              .with(id)
              .and_call_original
          end

          run_test!
        end
      end
    end
  end
end
