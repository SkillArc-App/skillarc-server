module Klayvio
  class UserSignup
    def call(event:)
      Klayvio.new.user_signup(
        email: event.data[:email],
        event_id: event.id,
        occurred_at: event.occurred_at
      )
    end
  end
end
