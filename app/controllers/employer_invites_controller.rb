class EmployerInvitesController < ApplicationController
  include Secured
  include Admin

  before_action :authorize
  before_action :admin_authorize

  def index
    render json: EmployerInvite.all.map { |invite| serialize_invite(invite) }
  end

  def create
    invite = EmployerInvite.create!(**params.require(:employer_invite).permit(:email, :first_name, :last_name, :employer_id), id: SecureRandom.uuid)

    render json: invite
  end

  private

  def serialize_invite(invite)
    {
      email: invite.email,
      firstName: invite.first_name,
      lastName: invite.last_name,
      usedAt: invite.used_at,
      employerName: invite.employer.name
    }
  end
end
