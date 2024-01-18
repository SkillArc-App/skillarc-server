class EmployerInviteService
  def initialize(employer_invite)
    @employer_invite = employer_invite
  end

  def accept
    EventService.create!(
      event_type: Event::EventTypes::EMPLOYER_INVITE_ACCEPTED,
      aggregate_id: employer_invite.employer_id,
      data: {
        employer_invite_id: employer_invite.id,
        invite_email: employer_invite.email,
        employer_id: employer_invite.employer_id,
        employer_name: employer_invite.employer.name
      },
      occurred_at: Time.now.utc.iso8601,
      metadata: {}
    )

    user = User.find_by(email: employer_invite.email)

    EmployerInvite.transaction do
      employer_invite.update!(used_at: DateTime.now)
      Recruiter.create!(
        id: SecureRandom.uuid,
        employer_id: employer_invite.employer_id,
        user:
      )
    end
  end

  private

  attr_reader :employer_invite
end
