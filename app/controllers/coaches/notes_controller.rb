module Coaches
  class NotesController < ApplicationController
    include Secured
    include CoachAuth
    include EventEmitter

    before_action :authorize
    before_action :coach_authorize
    before_action :set_coach

    def create
      with_event_service do
        SeekerService.new(event_service:).add_note(
          coach:,
          context_id: params[:context_id],
          note: params[:note],
          note_id: params[:note_id] || SecureRandom.uuid
        )
      end

      head :accepted
    end

    def update
      with_event_service do
        SeekerService.new(event_service:).modify_note(
          context_id: params[:context_id],
          coach:,
          note_id: params[:id],
          note: params[:note]
        )
      end

      head :accepted
    end

    def destroy
      with_event_service do
        SeekerService.new(event_service:).delete_note(
          coach:,
          context_id: params[:context_id],
          note_id: params[:id]
        )
      end

      head :accepted
    end

    private

    attr_reader :coach

    def set_coach
      @coach = Coach.find_by(user_id: current_user.id)
    end
  end
end
