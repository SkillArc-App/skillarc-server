module Coaches
  class BarriersController < ApplicationController
    include Secured
    include CoachAuth

    before_action :authorize
    before_action :coach_authorize

    def index
      render json: BarrierService.all
    end
  end
end
