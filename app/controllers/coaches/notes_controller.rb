module Coaches
  class NotesController < ApplicationController
    include Secured
    include CoachAuth

    before_action :authorize
    before_action :coach_authorize

    def create
      CoachSeekers.add_note(
        params[:seeker_id],
        params[:note],
        params[:id] || SecureRandom.uuid
      )

      render json: {}
    end
  end
end
