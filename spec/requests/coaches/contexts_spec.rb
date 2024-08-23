require 'rails_helper'
require 'swagger_helper'

RSpec.describe "Coaches::Contexts", type: :request do
  path '/coaches/contexts' do
    get "Retrieve all contexts" do
      tags 'Coaches'
      produces 'application/json'
      parameter name: :utm_term, in: :query, type: :string
      parameter name: :attributes, in: :query, type: :string
      security [bearer_auth: []]

      include_context "olive branch casing parameter"
      include_context "olive branch camelcasing"

      it_behaves_like "coach spec unauthenticated openapi"

      let(:utm_term) { nil }
      let(:attributes) { nil }

      context "when authenticated" do
        include_context "coach authenticated openapi"

        response '200', 'retrieve all seekers' do
          schema type: :array,
                 items: {
                   '$ref' => '#/components/schemas/coach_seeker_table'
                 }

          let(:attribute_id) { SecureRandom.uuid }

          before do
            person_context1 = create(:coaches__person_context)
            person_context2 = create(:coaches__person_context)

            create(:people_search__person, id: person_context1.id)
            create(:people_search__person, id: person_context2.id)

            create(:coaches__person_note, person_context: person_context1)
            create(:coaches__person_application, person_context: person_context2)
            create(:coaches__person_job_recommendation, person_context: person_context2)
          end

          context "when no search params are provided" do
            let(:utm_term) { nil }
            let(:attributes) { nil }

            run_test!
          end

          context "when search params are provided" do
            let(:utm_term) { "trainer" }
            let(:attributes) do
              {
                attribute_id => ["Example"]
              }.to_json
            end

            before do
              expect(PeopleSearch::PeopleQuery)
                .to receive(:search)
                .with(
                  search_terms: utm_term,
                  attributes: {
                    attribute_id => ["Example"]
                  },
                  user:,
                  message_service: be_a(MessageService)
                )
                .and_call_original
            end

            run_test!
          end
        end
      end
    end
  end

  path '/coaches/contexts/{id}' do
    get "Retrieve a context" do
      tags 'Coaches'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string
      security [bearer_auth: []]

      include_context "olive branch casing parameter"
      include_context "olive branch camelcasing"

      it_behaves_like "coach spec unauthenticated openapi"

      let(:person_context) { create(:coaches__person_context) }
      let(:id) { person_context.id }

      context "when authenticated" do
        include_context "coach authenticated openapi"

        response '404', 'seeker not found' do
          let(:id) { SecureRandom.uuid }

          run_test!
        end

        response '200', 'retrieve all seekers' do
          schema '$ref' => '#/components/schemas/coach_seeker'

          before do
            create(:coaches__person_note, person_context:)
            create(:coaches__contact, person_context:)
            create(:coaches__person_application, person_context:)
            create(:coaches__person_job_recommendation, person_context:)

            expect_any_instance_of(MessageService)
              .to receive(:create!)
              .with(
                schema: Events::PersonViewedInCoaching::V1,
                coach_id: coach.id,
                data: {
                  person_id: id
                }
              )

            expect(Coaches::CoachesQuery)
              .to receive(:find_person)
              .with(id)
              .and_call_original
          end

          run_test!
        end
      end
    end
  end

  path '/coaches/contexts/{id}/assign_coach' do
    post "Update a skill level" do
      tags 'Seekers'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter name: :update, in: :body, schema: {
        type: :object,
        properties: {
          coachId: {
            type: :string,
            format: :uuid
          }
        },
        required: %w[coachId]
      }
      security [bearer_auth: []]

      include_context "olive branch casing parameter"
      include_context "olive branch camelcasing"

      it_behaves_like "coach spec unauthenticated openapi"

      let(:person_context) { create(:coaches__person_context) }
      let(:coach) { create(:coaches__coach) }
      let(:coach_id) { coach.id }
      let(:id) { person_context.id }
      let(:update) do
        {
          coachId: coach_id
        }
      end

      context "when authenticated" do
        include_context "coach authenticated openapi"

        response '404', 'Coach not found' do
          let(:coach_id) { SecureRandom.uuid }

          run_test!
        end

        response '202', 'retrieve all seekers' do
          before do
            expect_any_instance_of(Coaches::CoachesEventEmitter)
              .to receive(:assign_coach)
              .with(person_id: id, coach_id:, trace_id: be_a(String))
          end

          run_test!
        end
      end
    end
  end

  path '/coaches/contexts/{id}/recommend_job' do
    post "Update a skill level" do
      tags 'Seekers'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter name: :update, in: :body, schema: {
        type: :object,
        properties: {
          jobId: {
            type: :string,
            format: :uuid
          }
        },
        required: %w[jobId]
      }
      security [bearer_auth: []]

      include_context "olive branch casing parameter"
      include_context "olive branch camelcasing"

      it_behaves_like "coach spec unauthenticated openapi"

      let(:person_context) { create(:coaches__person_context) }
      let(:id) { person_context.id }
      let(:job_id) { job.job_id }
      let(:job) { create(:coaches__job) }
      let(:update) do
        {
          jobId: job_id
        }
      end

      context "when authenticated" do
        include_context "coach authenticated openapi"

        response '202', 'retrieve all seekers' do
          before do
            expect_any_instance_of(Coaches::CoachesEventEmitter)
              .to receive(:recommend_job)
              .with(
                person_id: id,
                job_id:,
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
