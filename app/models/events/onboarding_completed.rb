module Events
  module OnboardingCompleted
    V1 = Schema.build(
      data: Common::UntypedHashWrapper,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::ONBOARDING_COMPLETED,
      version: 1
    )
  end
end
