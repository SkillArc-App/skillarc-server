class IndustriesController < ApplicationController
  def index
    render json: Industries::Industry.first&.industries || []
  end
end
