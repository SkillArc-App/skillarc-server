module Klayvio
  class UserUpdated
    include DefaultStreamId

    def call(message:)
      data = message.data.to_h

      Klayvio.new.user_updated(
        email: data[:email],
        event_id: message.id,
        occurred_at: message.occurred_at,
        profile_attributes: {
          first_name: data[:first_name],
          last_name: data[:last_name],
          phone_number: E164.normalize(message.data[:phone_number])
        },
        profile_properties: {
          date_of_birth: data[:date_of_birth]
        }
      )
    end
  end
end
