class CoachesController < ApplicationController
  include Secured
  include CoachAuth

  before_action :authorize
  before_action :coach_authorize

  def index
    render json: Coaches::CoachService.new.all
  end
end
