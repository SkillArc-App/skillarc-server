module Klayvio
  class UserSignup
    def call(message:)
      Klayvio.new.user_signup(
        email: message.data[:email],
        event_id: message.id,
        occurred_at: message.occurred_at
      )
    end
  end
end
