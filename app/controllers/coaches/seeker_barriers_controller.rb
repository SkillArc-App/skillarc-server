module Coaches
  class SeekerBarriersController < ApplicationController
    include Secured
    include CoachAuth
    include EventEmitter

    before_action :authorize
    before_action :coach_authorize

    def update_all
      with_event_service do
        SeekerService.new(event_service:).update_barriers(
          context_id: params[:context_id],
          barriers: params[:barriers]
        )
      end

      head :accepted
    end
  end
end
