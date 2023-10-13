class TrainingProviders::ProgramsController < ApplicationController
  include Secured
  include Admin
  include TrainingProviderAuth

  before_action :authorize

  # 😱 These controllers definitely need to be separated
  before_action :admin_authorize, only: [:create, :update]
  before_action :training_provider_authorize, only: [:index]

  before_action :set_training_provider, only: [:create, :update]

  def index
    render json: training_provider_profile.training_provider.programs
  end

  def create
    program = training_provider.programs.create!(**params.require(:program).permit(:name, :description), id: SecureRandom.uuid)

    render json: program
  end

  def update
    program = training_provider.programs.find(params[:id])

    program.update!(**params.require(:program).permit(:name, :description))

    render json: program
  end

  private

  attr_reader :training_provider

  def set_training_provider
    @training_provider = TrainingProvider.find(params[:training_provider_id])
  end
end
