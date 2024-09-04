class AttributesController < ApplicationController
  def index
    render json: Attributes::AttributesQuery.all
  end
end
