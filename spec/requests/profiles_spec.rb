require 'rails_helper'
require 'swagger_helper'

RSpec.describe "Profiles", type: :request do
  path '/profiles' do
    get "Retrieve all seekers" do
      tags 'Seekers'
      produces 'application/json'
      security [bearer_auth: []]

      include_context "olive branch casing parameter"
      include_context "olive branch camelcasing"

      it_behaves_like "admin spec unauthenticated openapi"

      context "when authenticated" do
        before do
          create(:seeker)
          seeker = create(:seeker)

          program = create(:program)
          create(:seeker_training_provider, user: seeker.user, program:, training_provider: program.training_provider)
        end

        include_context "admin authenticated openapi"

        response '200', 'profiles retrieved' do
          schema type: :array,
                 items: {
                   type: :object,
                   properties: {
                     id: {
                       type: :string,
                       format: :uuid
                     },
                     firstName: {
                       type: :string
                     },
                     lastName: {
                       type: :string
                     },
                     email: {
                       type: :string,
                       format: :email
                     },
                     trainingProvider: {
                       type: :array,
                       items: {
                         type: :object,
                         properties: {
                           id: {
                             type: :string,
                             format: :uuid
                           },
                           name: {
                             type: :string
                           }
                         }
                       }
                     }
                   }
                 }

          run_test!
        end
      end
    end
  end

  path "/profiles/{id}" do
    get "Retrieve a seeker" do
      tags 'Seekers'
      produces 'application/json'
      security [bearer_auth: []]
      parameter name: :id, in: :path, type: :string

      include_context "olive branch casing parameter"
      include_context "olive branch camelcasing"

      let(:id) { seeker.id }
      let(:seeker) { create(:seeker) }

      response '404', 'Seeker not found' do
        include_context "unauthenticated openapi"

        let(:id) { SecureRandom.uuid }

        run_test!
      end

      response '200', 'profiles retrieved' do
        schema "$ref" => "#/components/schemas/seeker"

        context "when unauthticated" do
          include_context "unauthenticated openapi"

          before do
            expect_any_instance_of(SeekerService)
              .to receive(:get)
              .with(user_id: nil, seeker_editor: false)
              .and_call_original
          end

          context "when seeker is empty" do
            let(:seeker) { create(:seeker) }

            run_test!
          end

          context "when seeker is fully specified" do
            before do
              create(:education_experience, seeker:)
              create(:other_experience, seeker:)
              create(:personal_experience, seeker:)
              create(:profile_skill, seeker:)
              create(:reference, seeker:)
              create(:seeker_training_provider, user: seeker.user)
            end

            let(:seeker) { create(:seeker) }

            run_test!
          end
        end

        context "when authenticated" do
          context "when the user is the seeker" do
            include_context "authenticated openapi"

            before do
              expect_any_instance_of(SeekerService)
                .to receive(:get)
                .with(user_id: user.id, seeker_editor: true)
                .and_call_original
            end

            context "when seeker is empty" do
              let(:seeker) { create(:seeker, user:) }

              run_test!
            end

            context "when seeker is fully specified" do
              before do
                create(:education_experience, seeker:)
                create(:other_experience, seeker:)
                create(:personal_experience, seeker:)
                create(:profile_skill, seeker:)
                create(:reference, seeker:)
                create(:seeker_training_provider, user: seeker.user)
              end

              let(:seeker) { create(:seeker, user:) }

              run_test!
            end
          end

          context "when the user is a coach" do
            include_context "coach authenticated openapi"

            before do
              expect_any_instance_of(SeekerService)
                .to receive(:get)
                .with(user_id: user.id, seeker_editor: true)
                .and_call_original
            end

            context "when seeker is empty" do
              let(:seeker) { create(:seeker) }

              run_test!
            end

            context "when seeker is fully specified" do
              before do
                create(:education_experience, seeker:)
                create(:other_experience, seeker:)
                create(:personal_experience, seeker:)
                create(:profile_skill, seeker:)
                create(:reference, seeker:)
                create(:seeker_training_provider, user: seeker.user)
              end

              let(:seeker) { create(:seeker) }

              run_test!
            end
          end
        end
      end
    end
  end
end
