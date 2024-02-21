require 'rails_helper'
require 'swagger_helper'

RSpec.describe "Coaches::Seekers", type: :request do
  path '/coaches/seekers' do
    get "Retrieve all seekers" do
      tags 'Coaches'
      produces 'application/json'
      security [bearer_auth: []]

      include_context "olive branch casing parameter"
      include_context "olive branch camelcasing"

      it_behaves_like "coach spec unauthenticated openapi"

      context "when authenticated" do
        include_context "coach authenticated openapi"

        response '200', 'retrieve all seekers' do
          schema type: :array,
                 items: {
                   '$ref' => '#/components/schemas/coach_seeker'
                 }

          context "when are no seekers" do
            run_test!
          end

          context "when there are many seekers" do
            before do
              csc1 = create(:coaches__coach_seeker_context)
              csc2 = create(:coaches__coach_seeker_context)

              create(:coaches__seeker_note, coach_seeker_context: csc1)
              create(:coaches__seeker_barrier, coach_seeker_context: csc1)
              create(:coaches__seeker_application, coach_seeker_context: csc2)
              create(:coaches__seeker_job_recommendation, coach_seeker_context: csc2)
            end

            run_test!
          end
        end
      end
    end
  end

  path '/coaches/seekers/{id}' do
    get "Retrieve a seekers" do
      tags 'Coaches'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string
      security [bearer_auth: []]

      include_context "olive branch casing parameter"
      include_context "olive branch camelcasing"

      it_behaves_like "coach spec unauthenticated openapi"

      let(:coach_seeker_context) { create(:coaches__coach_seeker_context) }
      let(:id) { coach_seeker_context.seeker_id }

      context "when authenticated" do
        include_context "coach authenticated openapi"

        response '404', 'seeker not found' do
          let(:id) { SecureRandom.uuid }

          run_test!
        end

        response '200', 'retrieve all seekers' do
          schema '$ref' => '#/components/schemas/coach_seeker'

          before do
            create(:coaches__seeker_note, coach_seeker_context:)
            create(:coaches__seeker_barrier, coach_seeker_context:)
            create(:coaches__seeker_application, coach_seeker_context:)
            create(:coaches__seeker_job_recommendation, coach_seeker_context:)

            expect(Coaches::SeekerService)
              .to receive(:find_context)
              .with(id)
              .and_call_original
          end

          run_test!
        end
      end
    end
  end

  path '/coaches/seekers/{id}/skill-levels' do
    post "Update a skill level" do
      tags 'Seekers'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter name: :update, in: :body, schema: {
        type: :object,
        properties: {
          level: {
            type: :string
          }
        },
        required: %w[level]
      }
      security [bearer_auth: []]

      include_context "olive branch casing parameter"
      include_context "olive branch camelcasing"

      it_behaves_like "coach spec unauthenticated openapi"

      let(:coach_seeker_context) { create(:coaches__coach_seeker_context) }
      let(:id) { coach_seeker_context.seeker_id }
      let(:update) do
        {
          level: "advanced"
        }
      end

      context "when authenticated" do
        include_context "coach authenticated openapi"

        response '202', 'retrieve all seekers' do
          before do
            expect(Coaches::SeekerService)
              .to receive(:update_skill_level)
              .with(id, update[:level])
              .and_call_original
          end

          run_test!
        end
      end
    end
  end

  path '/coaches/seekers/{id}/assign_coach' do
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

      let(:coach_seeker_context) { create(:coaches__coach_seeker_context) }
      let(:coach) { create(:coaches__coach) }
      let(:coach_id) { coach.coach_id }
      let(:id) { coach_seeker_context.seeker_id }
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
            expect(Coaches::SeekerService)
              .to receive(:assign_coach)
              .with(id, coach_id, coach.email)
          end

          run_test!
        end
      end
    end
  end

  path '/coaches/seekers/{id}/recommend_job' do
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

      let(:coach_seeker_context) { create(:coaches__coach_seeker_context) }
      let(:id) { coach_seeker_context.seeker_id }
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
            expect(Coaches::SeekerService)
              .to receive(:recommend_job)
              .with(
                seeker_id: id,
                job_id:,
                coach:
              ).and_call_original
          end

          run_test!
        end
      end
    end
  end

  path '/coaches/seekers/{id}/certify' do
    post "Update a skill level" do
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

        response '202', 'retrieve all seekers' do
          before do
            expect(Coaches::SeekerService)
              .to receive(:certify)
              .with(
                seeker_id: id,
                coach:
              ).and_call_original
          end

          run_test!
        end
      end
    end
  end
end
