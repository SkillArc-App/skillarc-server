class TrainingProvidersController < ApplicationController
  include Secured
  include Admin

  before_action :authorize
  before_action :admin_authorize, only: [:create]

  def create
    tp = TrainingProvider.create!(**params.require(:training_provider).permit(:name, :description), id: SecureRandom.uuid)

    render json: serialize_training_provider(tp)
  end

  def index
    render json: TrainingProvider.all.map { |tp| serialize_training_provider(tp) }
  end

  def show
    render json: serialize_training_provider(TrainingProvider.find(params[:id]))
  end

  private

  def serialize_training_provider(tp)
    {
      **tp.as_json,
      program: tp.programs
    }
  end
end
