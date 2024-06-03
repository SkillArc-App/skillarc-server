require 'rails_helper'
require 'swagger_helper'

RSpec.describe "Coaches::Seekers", type: :request do
  path '/coaches/seekers/{id}/certify' do
    post "Certify a seeker" do
      tags 'Seekers'
      parameter name: :id, in: :path, type: :string
      security [bearer_auth: []]

      include_context "olive branch casing parameter"
      include_context "olive branch camelcasing"

      it_behaves_like "coach spec unauthenticated openapi"

      let(:coach_seeker_context) { create(:coaches__coach_seeker_context) }
      let(:id) { coach_seeker_context.seeker_id }

      context "when authenticated" do
        include_context "coach authenticated openapi"

        response '202', 'certifies a seeker' do
          before do
            expect_any_instance_of(Coaches::CoachesReactor)
              .to receive(:certify)
              .with(
                person_id: id,
                coach:,
                trace_id: be_a(String)
              ).and_call_original
          end

          run_test!
        end
      end
    end
  end
end
