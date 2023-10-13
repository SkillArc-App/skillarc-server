class SeekerInvitesController < ApplicationController
  include Secured
  include Admin

  before_action :authorize
  before_action :admin_authorize

  def index
    render json: SeekerInvite.all.map { |invite| serialize_invite(invite) }
  end

  def create
    invite = SeekerInvite.create!(**params.require(:seeker_invite).permit(:email, :first_name, :last_name, :program_id, :training_provider_id), id: SecureRandom.uuid)

    render json: invite
  end

  private

  def serialize_invite(invite)
    {
      **invite.as_json,
      trainingProviderName: invite.training_provider.name,
      programName: invite.program.name
    }
  end
end
