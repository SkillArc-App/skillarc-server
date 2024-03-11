class EmployersController < ApplicationController
  include Secured
  include Admin
  include EventEmitter

  before_action :authorize
  before_action :admin_authorize

  def index
    with_event_service do
      render json: Employer.all
    end
  end

  def show
    with_event_service do
      render json: Employer.find(params[:id])
    end
  end

  def create
    with_event_service do
      employer = EmployerService.new.create(**params.require(:employer).permit(:name, :bio, :logo_url, :location), id: SecureRandom.uuid)

      render json: employer
    end
  end

  def update
    with_event_service do
      employer = EmployerService.new.update(employer_id: params[:id], params: params.require(:employer).permit(:name, :bio, :logo_url, :location))

      render json: employer
    end
  end
end
