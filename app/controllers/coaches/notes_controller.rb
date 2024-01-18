module Coaches
  class NotesController < ApplicationController
    include Secured
    include CoachAuth

    before_action :authorize
    before_action :coach_authorize
    before_action :set_coach

    def create
      SeekerService.add_note(
        coach:,
        id: params[:seeker_id],
        note: params[:note],
        note_id: params[:note_id] || SecureRandom.uuid
      )

      render json: {}
    end

    def update
      SeekerService.modify_note(
        id: params[:seeker_id],
        coach:,
        note_id: params[:id],
        note: params[:note]
      )

      head :accepted
    end

    def destroy
      SeekerService.delete_note(
        coach:,
        id: params[:seeker_id],
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
