module Coaches
  class SeekerBarriersController < ApplicationController
    include Secured
    include CoachAuth

    before_action :authorize
    before_action :coach_authorize

    def update_all
      SeekerService.update_barriers(
        id: params[:seeker_id],
        barriers: params[:barriers]
      )

      render json: {}
    end
  end
end
