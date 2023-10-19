module Klayvio
  class UserSignup
    def call(event)
      Klayvio.user_signup(
        email: event.data["email"],
        occurred_at: event.occurred_at
      )
    end
  end
end