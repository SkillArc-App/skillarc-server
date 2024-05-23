class ReferencesController < ApplicationController
  include Secured
  include TrainingProviderAuth
  include MessageEmitter

  before_action :authorize
  before_action :training_provider_authorize

  def show
    render json: training_provider_profile.references.find(params[:id])
  end

  def create
    with_message_service do
      TrainingProviders::TrainingProviderReactor.new(message_service:).create_reference(
        seeker_id: params[:seeker_profile_id],
        reference_text: params[:reference],
        author_training_provider_profile_id: training_provider_profile.id,
        trace_id: request.request_id
      )
    end

    head :created
  end

  def update
    with_message_service do
      TrainingProviders::TrainingProviderReactor.new(message_service:).update_reference(
        reference_id: params[:id],
        reference_text: params[:reference_text],
        trace_id: request.request_id
      )
    end

    head :ok
  end
end
