module Events
  module OnboardingCompleted
    V1 = Messages::Schema.build(
      data: Messages::UntypedHashWrapper,
      metadata: Messages::Nothing,
      event_type: Event::EventTypes::ONBOARDING_COMPLETED,
      version: 1
    )
  end
end
