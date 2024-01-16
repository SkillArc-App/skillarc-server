module Coaches
  class NotesController < ApplicationController
    include Secured
    include CoachAuth

    before_action :authorize
    before_action :coach_authorize

    def create
      SeekerService.add_note(
        params[:seeker_id],
        params[:note],
        params[:note_id] || SecureRandom.uuid
      )

      render json: {}
    end

    def update
      SeekerService.modify_note(
        params[:seeker_id],
        params[:id],
        params[:note]
      )

      head :accepted
    end

    def destroy
      SeekerService.delete_note(
        params[:seeker_id],
        params[:id]
      )

      head :accepted
    end
  end
end
