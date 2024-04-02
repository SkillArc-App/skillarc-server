module Klayvio
  class UserSignup
    include DefaultStreamId

    def call(message:)
      Gateway.build.user_signup(
        email: message.data[:email],
        event_id: message.id,
        occurred_at: message.occurred_at
      )
    end
  end
end
