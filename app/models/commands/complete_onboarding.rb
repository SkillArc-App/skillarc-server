module Commands
  module CompleteOnboarding
    V1 = Core::Schema.inactive(
      type: Core::COMMAND,
      data: Core::Nothing,
      metadata: Core::Nothing,
      aggregate: Streams::Seeker,
      message_type: MessageTypes::Person::COMPLETE_ONBOARDING,
      version: 1
    )
    V2 = Core::Schema.active(
      type: Core::COMMAND,
      data: Core::Nothing,
      metadata: Core::Nothing,
      aggregate: Streams::Person,
      message_type: MessageTypes::Person::COMPLETE_ONBOARDING,
      version: 2
    )
  end
end
