class ReferencesController < ApplicationController
  include Secured
  include TrainingProviderAuth

  before_action :authorize
  before_action :training_provider_authorize

  def show
    render json: training_provider_profile.references.find(params[:id])
  end

  def create
    r = Reference.create!(
      id: SecureRandom.uuid,
      author_profile: training_provider_profile,
      reference_text: params[:reference],
      seeker_profile_id: params[:seeker_profile_id],
      seeker_id: params[:seeker_profile_id],
      training_provider: training_provider_profile.training_provider
    )

    render json: r
  end

  def update
    r = training_provider_profile.references.find(params[:id])

    r.update!(params.require(:reference).permit(:reference_text))

    render json: r
  end
end
