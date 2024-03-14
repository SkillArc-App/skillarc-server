module Coaches
  class SeekersController < ApplicationController
    include Secured
    include CoachAuth
    include EventEmitter

    before_action :authorize
    before_action :coach_authorize
    before_action :set_coach, only: %i[certify]

    def certify
      with_event_service do
        SeekerReactor.new(event_service:).certify(seeker_id: params[:seeker_id], coach:, trace_id: request.request_id)
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
