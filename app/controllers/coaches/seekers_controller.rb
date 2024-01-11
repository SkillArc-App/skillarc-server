module Coaches
  class SeekersController < ApplicationController
    include Secured
    include CoachAuth

    before_action :authorize
    before_action :coach_authorize

    def index
      render json: CoachSeekers.all
    end

    def show
      render json: CoachSeekers.find(params[:id])
    end

    def assign
      coach = Coach.find_by(id: params[:coach_id])

      CoachSeekers.assign_coach(
        params[:seeker_id],
        coach.id,
        coach.email
      )

      render json: {}
    end

    def update_skill_level
      CoachSeekers.update_skill_level(
        params[:seeker_id],
        params[:level]
      )

      render json: {}
    end
  end
end
