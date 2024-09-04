require 'rails_helper'
require 'swagger_helper'

RSpec.describe "Industries", type: :request do
  path '/industries' do
    get "Get all industries" do
      tags 'Other'
      produces 'application/json'

      include_context "olive branch casing parameter"
      include_context "olive branch camelcasing"

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
