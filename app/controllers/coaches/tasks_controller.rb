module Coaches
  class TasksController < ApplicationController
    include Secured
    include CoachAuth
    include MessageEmitter

    before_action :authorize
    before_action :coach_authorize
    before_action :set_coach

    def index
      render json: CoachesQuery.reminders(coach)
    end

    def create_reminder
      with_message_service do
        CoachesReactor.new(message_service:).create_reminder(
          coach:,
          note: params[:note],
          reminder_at: Time.zone.parse(params[:reminder_at]),
          context_id: params[:context_id],
          trace_id: request.request_id
        )
      end

      head :accepted
    end

    def complete_reminder
      with_message_service do
        CoachesReactor.new(message_service:).complete_reminder(
          reminder_id: params[:id],
          coach:,
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
