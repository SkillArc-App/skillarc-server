module Events
  module OnboardingCompleted
    V1 = Messages::Schema.build(
      data: Messages::UntypedHashWrapper,
      metadata: Messages::Nothing,
      message_type: Messages::Types::Seekers::ONBOARDING_COMPLETED,
      version: 1
    )
  end
end
