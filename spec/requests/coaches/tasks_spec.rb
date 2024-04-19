require 'rails_helper'
require 'swagger_helper'

RSpec.describe "Tasks", type: :request do
  path '/coaches/tasks' do
    get "get all coach tasks" do
      tags 'Coaches'
      produces 'application/json'
      security [bearer_auth: []]

      include_context "olive branch casing parameter"
      include_context "olive branch camelcasing"

      it_behaves_like "coach spec unauthenticated openapi"

      context "when authenticated" do
        include_context "coach authenticated openapi"

        response '200', 'Creates a note' do
          schema type: :array,
                 items: {
                   '$ref' => '#/components/schemas/reminder'
                 }

          before do
            create(:coaches__reminder, coach:)
            create(:coaches__reminder, coach:, context_id: SecureRandom.uuid)
          end

          before do
            expect(Coaches::CoachesQuery)
              .to receive(:reminders)
              .with(coach)
              .and_call_original
          end

          run_test!
        end
      end
    end
  end

  path '/coaches/tasks/reminders' do
    post "create a reminder" do
      tags 'Coaches'
      consumes 'application/json'
      security [bearer_auth: []]

      parameter name: :reminder_params, in: :body, schema: {
        type: :object,
        properties: {
          note: {
            type: :string
          },
          reminderAt: {
            type: :string,
            format: 'date-time'
          },
          contextId: {
            type: :string,
            format: :uuid
          }
        },
        required: %w[reminderAt note]
      }

      include_context "olive branch casing parameter"
      include_context "olive branch camelcasing"

      it_behaves_like "coach spec unauthenticated openapi"

      let(:reminder_params) do
        {
          note:,
          reminderAt: reminder_at.to_s,
          contextId: context_id
        }
      end
      let(:note) { "A note" }
      let(:reminder_at) { Time.zone.local(2025, 1, 1) }
      let(:context_id) { SecureRandom.uuid }

      context "when authenticated" do
        include_context "coach authenticated openapi"

        response '202', 'Creates a reminder' do
          before do
            expect_any_instance_of(Coaches::CoachesReactor)
              .to receive(:create_reminder)
              .with(coach:, note:, reminder_at:, context_id:, trace_id: be_a(String))
              .and_call_original
          end

          run_test!
        end
      end
    end
  end

  path '/coaches/tasks/reminders/{id}/complete' do
    put "complete a reminder" do
      tags 'Coaches'
      parameter name: :id, in: :path, type: :string
      security [bearer_auth: []]

      include_context "olive branch casing parameter"
      include_context "olive branch camelcasing"

      it_behaves_like "coach spec unauthenticated openapi"

      let(:reminder) { create(:coaches__reminder) }
      let(:id) { reminder.id }

      context "when authenticated" do
        include_context "coach authenticated openapi"

        let(:reminder) { create(:coaches__reminder, coach:) }

        response '202', 'Completes a reminder' do
          before do
            expect_any_instance_of(Coaches::CoachesReactor)
              .to receive(:complete_reminder)
              .with(coach:, reminder_id: id, trace_id: be_a(String))
              .and_call_original
          end

          run_test!
        end
      end
    end
  end
end
