module Commands
  module CompleteOnboarding
    V1 = Messages::Schema.deprecated(
      type: Messages::COMMAND,
      data: Messages::Nothing,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Seeker,
      message_type: Messages::Types::Person::COMPLETE_ONBOARDING,
      version: 1
    )
    V2 = Messages::Schema.active(
      type: Messages::COMMAND,
      data: Messages::Nothing,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Person,
      message_type: Messages::Types::Person::COMPLETE_ONBOARDING,
      version: 2
    )
  end
end
