module Klayvio
  class EmployerInviteAccepted
    include DefaultStreamId

    def call(message:)
      Gateway.build.employer_invite_accepted(
        event_id: message.id,
        email: message.data[:invite_email],
        profile_properties: {
          is_recruiter: true,
          employer_name: message.data[:employer_name],
          employer_id: message.data[:employer_id]
        },
        occurred_at: message.occurred_at
      )
    end
  end
end
