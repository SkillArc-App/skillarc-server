module Coaches
  class NotesController < ApplicationController
    include Secured
    include CoachAuth

    before_action :authorize
    before_action :coach_authorize
    before_action :set_coach

    def create
      SeekerService.new.add_note(
        coach:,
        context_id: params[:context_id],
        note: params[:note],
        note_id: params[:note_id] || SecureRandom.uuid
      )

      head :accepted
    end

    def update
      SeekerService.new.modify_note(
        context_id: params[:context_id],
        coach:,
        note_id: params[:id],
        note: params[:note]
      )

      head :accepted
    end

    def destroy
      SeekerService.new.delete_note(
        coach:,
        context_id: params[:context_id],
        note_id: params[:id]
      )

      head :accepted
    end

    private

    attr_reader :coach

    def set_coach
      @coach = Coach.find_by(user_id: current_user.id)
    end
  end
end
