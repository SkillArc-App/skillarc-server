module Coaches
  class ContextsController < ApplicationController
    include Secured
    include CoachAuth
    include EventEmitter

    before_action :authorize
    before_action :coach_authorize
    before_action :set_coach, only: %i[recommend_job certify]

    def index
      with_event_service do
        render json: SeekerAggregator.new(event_service:).all_seekers
      end
    end

    def show
      with_event_service do
        render json: SeekerAggregator.new(event_service:).find_context(params[:id])
      end
    end

    def assign
      coach = Coach.find_by!(coach_id: params[:coach_id])

      with_event_service do
        SeekerReactor.new(event_service:).assign_coach(
          context_id: params[:context_id],
          coach_id: coach.coach_id,
          coach_email: coach.email
        )
      end

      head :accepted
    end

    def recommend_job
      with_event_service do
        SeekerReactor.new(event_service:).recommend_job(
          context_id: params[:context_id],
          job_id: params[:job_id],
          coach:
        )
      end

      head :accepted
    end

    def certify
      with_event_service do
        SeekerReactor.new(event_service:).certify(context_id: params[:context_id], coach:)
      end

      head :accepted
    end

    def update_skill_level
      with_event_service do
        SeekerReactor.new(event_service:).update_skill_level(
          context_id: params[:context_id],
          skill_level: params[:level]
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
