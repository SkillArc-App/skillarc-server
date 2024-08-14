require 'rails_helper'
require 'swagger_helper'

RSpec.describe "Industries", type: :request do
  path '/industries' do
    get "Get all industries" do
      tags 'Other'
      produces 'application/json'
      security [bearer_auth: []]

      include_context "olive branch casing parameter"
      include_context "olive branch camelcasing"

      it_behaves_like "spec unauthenticated openapi"

      context "authenticated" do
        include_context "authenticated openapi"

        response '200', 'Retrieve all employers' do
          schema type: :array,
                 items: {
                   type: :string
                 }

          before do
            create(:industries__industry)
          end

          run_test!
        end
      end
    end
  end
end
