module Klayvio
  class UserUpdated
    include DefaultStreamId

    def call(message:)
      dob = message.data[:date_of_birth]
      dob = Date.parse(dob) if dob.is_a?(String)

      Klayvio.new.user_updated(
        email: message.data[:email],
        event_id: message.id,
        occurred_at: message.occurred_at,
        profile_attributes: {
          first_name: message.data[:first_name],
          last_name: message.data[:last_name],
          phone_number: E164.normalize(message.data[:phone_number])
        },
        profile_properties: {
          date_of_birth: dob
        }
      )
    end
  end
end
