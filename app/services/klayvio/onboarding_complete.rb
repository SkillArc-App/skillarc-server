module Klayvio
  class OnboardingComplete
    def call(event:)
      user = User.find(event.aggregate_id)

      Klayvio.new.onboarding_complete(
        email: user.email,
        event_id: event.id,
        occurred_at: event.occurred_at
      )
    end
  end
end
