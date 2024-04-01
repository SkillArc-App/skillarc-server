module Coaches
  class LeadsController < ApplicationController
    include Secured
    include CoachAuth
    include EventEmitter
    include CommandEmitter

    before_action :authorize
    before_action :coach_authorize
    before_action :set_coach

    def index
      render json: SeekerAggregator.new.all_leads
    end

    def create
      with_event_service do
        with_command_service do
          seeker_reactor = SeekerReactor.new(event_service:, command_service:)
          lead = lead_hash

          seeker_reactor.add_lead(
            **lead,
            lead_captured_by: coach.email,
            trace_id: request.request_id
          )

          seeker_reactor.assign_coach(
            context_id: lead[:lead_id],
            coach_id: coach.coach_id,
            coach_email: coach.email,
            trace_id: request.request_id
          )
        end
      end

      head :created
    end

    private

    attr_reader :coach

    def lead_hash
      lead = params.require(:lead).permit(
        :lead_id,
        :email,
        :phone_number,
        :first_name,
        :last_name
      ).to_h.symbolize_keys
      lead[:lead_id] ||= SecureRandom.uuid

      lead
    end

    def set_coach
      @coach = Coach.find_by(user_id: current_user.id)
    end
  end
end
