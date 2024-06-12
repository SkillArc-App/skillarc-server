module Commands
  module CompleteOnboarding
    V1 = Messages::Schema.inactive(
      type: Messages::COMMAND,
      data: Messages::Nothing,
      metadata: Messages::Nothing,
      stream: Streams::Seeker,
      message_type: Messages::Types::Person::COMPLETE_ONBOARDING,
      version: 1
    )
    V2 = Messages::Schema.active(
      type: Messages::COMMAND,
      data: Messages::Nothing,
      metadata: Messages::Nothing,
      stream: Streams::Person,
      message_type: Messages::Types::Person::COMPLETE_ONBOARDING,
      version: 2
    )
  end
end
