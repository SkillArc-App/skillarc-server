module Coaches
  class SeekersController < ApplicationController
    include Secured
    include CoachAuth

    before_action :authorize
    before_action :coach_authorize

    def index
      render json: SeekerService.all_contexts
    end

    def show
      render json: SeekerService.find_context(params[:id])
    end

    def assign
      coach = Coach.find_by(coach_id: params[:coach_id])

      SeekerService.assign_coach(
        params[:seeker_id],
        coach.coach_id,
        coach.email
      )

      render json: {}
    end

    def update_skill_level
      SeekerService.update_skill_level(
        params[:seeker_id],
        params[:level]
      )

      render json: {}
    end
  end
end
