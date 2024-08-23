module Coaches
  class TasksController < CoachesController
    before_action :set_coach

    def index
      render json: CoachesQuery.tasks(coach:, person_id: params[:context_id])
    end

    def create_reminder
      reminder = reminder_hash

      with_message_service do
        CoachesEventEmitter.new(message_service:).create_reminder(
          coach:,
          note: reminder[:note],
          reminder_at: Time.zone.parse(reminder[:reminder_at]),
          person_id: reminder[:context_id],
          trace_id: request.request_id
        )
      end

      head :accepted
    end

    def complete_reminder
      with_message_service do
        CoachesEventEmitter.new(message_service:).complete_reminder(
          reminder_id: params[:id],
          coach:,
          trace_id: request.request_id
        )
      end

      head :accepted
    end

    private

    def reminder_hash
      params.require(:reminder).permit(
        :context_id,
        :note,
        :reminder_at
      ).to_h.symbolize_keys
    end
  end
end
