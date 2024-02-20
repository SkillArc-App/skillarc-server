module Coaches
  class SeekersController < ApplicationController
    include Secured
    include CoachAuth

    before_action :authorize
    before_action :coach_authorize
    before_action :set_coach, only: %i[recommend_job certify]

    def index
      render json: SeekerService.all_contexts
    end

    def show
      render json: SeekerService.find_context(params[:id])
    end

    def assign
      coach = Coach.find_by!(coach_id: params[:coach_id])

      SeekerService.assign_coach(
        params[:seeker_id],
        coach.coach_id,
        coach.email
      )

      head :accepted
    end

    def recommend_job
      SeekerService.recommend_job(
        seeker_id: params[:seeker_id],
        job_id: params[:job_id],
        coach:
      )

      head :accepted
    end

    def certify
      SeekerService.certify(seeker_id: params[:seeker_id], coach:)

      head :accepted
    end

    def update_skill_level
      SeekerService.update_skill_level(
        params[:seeker_id],
        params[:level]
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
