module Klayvio
  class UserUpdated
    def call(event:)
      dob = event.data[:date_of_birth]
      dob = Date.parse(dob) if dob.is_a?(String)

      Klayvio.new.user_updated(
        email: event.data[:email],
        event_id: event.id,
        occurred_at: event.occurred_at,
        profile_attributes: {
          first_name: event.data[:first_name],
          last_name: event.data[:last_name],
          phone_number: E164.normalize(event.data[:phone_number])
        },
        profile_properties: {
          date_of_birth: dob
        }
      )
    end
  end
end
