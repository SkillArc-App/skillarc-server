module Events
  module OnboardingCompleted
    V1 = Schema.new(
      data: Common::UntypedHashWrapper,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::ONBOARDING_COMPLETED,
      version: 1
    )
  end
end
