module Coaches
  class JobsController < ApplicationController
    include Secured
    include CoachAuth

    before_action :authorize
    before_action :coach_authorize
    before_action :set_coach

    def index
      render json: JobService.new.all
    end

    private

    attr_reader :coach

    def set_coach
      @coach = Coach.find_by(user_id: current_user.id)
    end
  end
end
