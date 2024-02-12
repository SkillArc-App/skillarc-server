module Klayvio
  class OnboardingComplete
    include DefaultStreamId

    def call(message:)
      user = User.find(message.aggregate_id)

      Klayvio.new.onboarding_complete(
        email: user.email,
        event_id: message.id,
        occurred_at: message.occurred_at
      )
    end
  end
end
