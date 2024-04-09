class EmployerInvitesController < ApplicationController
  include Secured
  include Admin
  include MessageEmitter

  before_action :authorize
  before_action :admin_authorize, only: %i[index create]

  def index
    render json: EmployerInvite.all.map { |invite| serialize_invite(invite) }
  end

  def create
    with_message_service do
      invite = EmployerInvite.create!(**params.require(:employer_invite).permit(:email, :first_name, :last_name, :employer_id), id: SecureRandom.uuid)

      render json: invite
    end
  end

  def used
    with_message_service do
      invite = EmployerInvite.find(params[:employer_invite_id])

      EmployerInviteService.new(invite).accept

      render json: invite
    end
  end

  private

  def serialize_invite(invite)
    prefix = ENV.fetch('FRONTEND_URL', nil)

    {
      email: invite.email,
      firstName: invite.first_name,
      lastName: invite.last_name,
      usedAt: invite.used_at,
      employerName: invite.employer.name,
      link: "#{prefix}/invites/employers/#{invite.id}"
    }
  end
end
