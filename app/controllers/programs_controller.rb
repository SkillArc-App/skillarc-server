class ProgramsController < ApplicationController
  include Secured

  before_action :authorize

  def index
    render json: Program.all
  end
end
