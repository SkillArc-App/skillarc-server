class TrainingProviders::InvitesController < ApplicationController
  include Secured
  include TrainingProviderAuth

  before_action :authorize
  before_action :training_provider_authorize

  def create
    invites = []

    params.permit(invitees: [:email, :first_name, :last_name, :program_id])[:invitees].each do |invitee|
      invites << {
        **invitee.as_json,
        id: SecureRandom.uuid
      }
    end

    training_provider_profile
      .training_provider
      .seeker_invites
      .create!(invites)

    render json: invites
  end
end
