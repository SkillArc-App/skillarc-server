module Coaches
  class ContextsController < ApplicationController
    include Secured
    include CoachAuth

    before_action :authorize
    before_action :coach_authorize
    before_action :set_coach, only: %i[recommend_job certify]

    def index
      render json: SeekerService.new.all_seekers
    end

    def show
      render json: SeekerService.new.find_context(params[:id])
    end

    def assign
      coach = Coach.find_by!(coach_id: params[:coach_id])

      SeekerService.new.assign_coach(
        context_id: params[:context_id],
        coach_id: coach.coach_id,
        coach_email: coach.email
      )

      head :accepted
    end

    def recommend_job
      SeekerService.new.recommend_job(
        context_id: params[:context_id],
        job_id: params[:job_id],
        coach:
      )

      head :accepted
    end

    def certify
      SeekerService.new.certify(context_id: params[:context_id], coach:)

      head :accepted
    end

    def update_skill_level
      SeekerService.new.update_skill_level(
        context_id: params[:context_id],
        skill_level: params[:level]
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
