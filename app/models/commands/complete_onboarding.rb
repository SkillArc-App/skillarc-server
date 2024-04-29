module Commands
  module CompleteOnboarding
    V1 = Messages::Schema.active(
      type: Messages::COMMAND,
      data: Messages::Nothing,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Seeker,
      message_type: Messages::Types::Seekers::COMPLETE_ONBOARDING,
      version: 1
    )
  end
end
