module Coaches
  class SeekerBarriersController < ApplicationController
    include Secured
    include CoachAuth

    before_action :authorize
    before_action :coach_authorize

    def update_all
      SeekerService.new.update_barriers(
        context_id: params[:context_id],
        barriers: params[:barriers]
      )

      head :accepted
    end
  end
end
