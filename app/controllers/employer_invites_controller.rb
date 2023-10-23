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

  def used
    invite = EmployerInvite.find(params[:employer_invite_id])
    user = User.find_by(email: invite.email)

    EmployerInvite.transaction do
      invite.update!(used_at: DateTime.now)
      Recruiter.create!(
        id: SecureRandom.uuid,
        employer_id: invite.employer_id,
        user: user
      )
    end

    render json: invite
  end

  private

  def serialize_invite(invite)
    prefix = ENV['FRONTEND_URL']

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
