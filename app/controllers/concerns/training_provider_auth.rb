module TrainingProviderAuth
  def training_provider_authorize
    unless (@training_provider_profile = current_user.training_provider_profile)
      render json: { error: 'Not authorized' }, status: :unauthorized
      nil
    end
  end

  private

  attr_reader :training_provider_profile
end
