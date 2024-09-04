require 'rails_helper'
require 'swagger_helper'

RSpec.describe "Attributes", type: :request do
  path '/attributes' do
    get "get all attributes" do
      tags 'Attributes'
      produces 'application/json'

      include_context "olive branch casing parameter"
      include_context "olive branch camelcasing"

      response '200', 'Returns all attributes' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :string, format: :uuid },
                   description: { type: :string, nullable: true },
                   name: { type: :string },
                   set: {
                     type: :object,
                     additionalProperties: { type: :string }
                   },
                   default: {
                     type: :object,
                     additionalProperties: { type: :string }
                   },
                   machineDerived: { type: :boolean }
                 }
               }

        let!(:attribute) { create(:attributes_attribute) }

        before do
          expect(Attributes::AttributesQuery)
            .to receive(:all)
            .and_call_original
        end

        run_test!
      end
    end
  end
end
