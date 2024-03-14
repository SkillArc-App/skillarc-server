class TrainingProviderInvitesController < ApplicationController
  include Secured
  include Admin
  include EventEmitter

  before_action :authorize
  before_action :admin_authorize, only: %i[index create]

  def index
    render json: TrainingProviderInvite.all.map { |invite| serialize_invite(invite) }
  end

  def create
    with_event_service do
      invite = TrainingProviderInvite.create!(**params.require(:training_provider_invite).permit(:email, :first_name, :last_name, :role_description, :training_provider_id), id: SecureRandom.uuid)

      render json: invite
    end
  end

  def accept
    with_event_service do
      invite = TrainingProviderInvite.find(params[:id])

      TrainingProviderInviteService.new(invite).accept

      render json: serialize_invite(invite)
    end
  end

  private

  def serialize_invite(invite)
    {
      **invite.as_json,
      training_provider_name: invite.training_provider.name
    }
  end
end
