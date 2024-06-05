module Coaches
  class ContextsController < ApplicationController
    include Secured
    include CoachAuth
    include MessageEmitter

    before_action :authorize
    before_action :coach_authorize
    before_action :set_coach, only: %i[recommend_job show]

    def index
      render json: CoachesQuery.all_seekers
    end

    def show
      context = CoachesQuery.find_person(params[:id])

      with_message_service do
        message_service.create!(
          schema: Events::PersonViewedInCoaching::V1,
          coach_id: coach.id,
          data: {
            person_id: params[:id]
          }
        )
      end

      render json: context
    end

    def assign
      coach = Coach.find(params[:coach_id])

      with_message_service do
        CoachesEventEmitter.new(message_service:).assign_coach(
          person_id: params[:context_id],
          coach_id: coach.id,
          trace_id: request.request_id
        )
      end

      head :accepted
    end

    def recommend_job
      with_message_service do
        CoachesEventEmitter.new(message_service:).recommend_job(
          person_id: params[:context_id],
          job_id: params[:job_id],
          coach:,
          trace_id: request.request_id
        )
      end

      head :accepted
    end

    def update_skill_level
      with_message_service do
        CoachesEventEmitter.new(message_service:).update_skill_level(
          person_id: params[:context_id],
          skill_level: params[:level],
          trace_id: request.request_id
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
