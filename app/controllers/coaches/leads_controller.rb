module Coaches
  class LeadsController < ApplicationController
    include Secured
    include CoachAuth
    include EventEmitter

    before_action :authorize
    before_action :coach_authorize
    before_action :set_coach

    def index
      render json: SeekerAggregator.new.all_leads
    end

    def create
      with_event_service do
        SeekerReactor.new(event_service:).add_lead(
          lead_id: SecureRandom.uuid,
          **params.require(:lead).permit(
            :lead_id,
            :email,
            :phone_number,
            :first_name,
            :last_name
          ).to_h.symbolize_keys,
          coach:
        )
      end

      head :created
    end

    private

    attr_reader :coach

    def set_coach
      @coach = Coach.find_by(user_id: current_user.id)
    end
  end
end
