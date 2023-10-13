class EmployersController < ApplicationController
  include Secured
  include Admin

  before_action :authorize
  before_action :admin_authorize

  def create
    employer = Employer.create!(**params.require(:employer).permit(:name, :bio, :logo_url, :location), id: SecureRandom.uuid)

    render json: employer
  end

  def update
    employer = Employer.find(params[:id])

    employer.update!(**params.require(:employer).permit(:name, :bio, :logo_url, :location))

    render json: employer
  end

  def index
    render json: Employer.all
  end

  def show
    render json: Employer.find(params[:id])
  end
end
