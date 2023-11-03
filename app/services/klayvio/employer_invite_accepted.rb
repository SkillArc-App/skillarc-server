module Klayvio
  class EmployerInviteAccepted
    def call(event:)
      Klayvio.new.employer_invite_accepted(
        event_id: event.id,
        email: event.data["invite_email"],
        profile_properties: {
          is_recruiter: true,
          employer_name: event.data["employer_name"],
          employer_id: event.data["employer_id"],
        },
        occurred_at: event.occurred_at,
      )
    end
  end
end