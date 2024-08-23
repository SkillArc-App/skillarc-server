module Coaches
  class NotesController < CoachesController
    before_action :set_coach

    def create
      with_message_service do
        CoachesEventEmitter.new(message_service:).add_note(
          originator: coach.email,
          person_id: params[:context_id],
          note: params[:note],
          note_id: params[:note_id] || SecureRandom.uuid,
          trace_id: request.request_id
        )
      end

      head :accepted
    end

    def update
      with_message_service do
        CoachesEventEmitter.new(message_service:).modify_note(
          person_id: params[:context_id],
          originator: coach.email,
          note_id: params[:id],
          note: params[:note],
          trace_id: request.request_id
        )
      end

      head :accepted
    end

    def destroy
      with_message_service do
        CoachesEventEmitter.new(message_service:).delete_note(
          originator: coach.email,
          person_id: params[:context_id],
          note_id: params[:id],
          trace_id: request.request_id
        )
      end

      head :accepted
    end
  end
end
