module Commands
  module StartOnboarding
    module Data
      class V1
        extend Messages::Payload

        schema do
          user_id String
        end
      end
    end

    V1 = Messages::Schema.inactive(
      type: Messages::COMMAND,
      data: Data::V1,
      metadata: Messages::Nothing,
      stream: Streams::Seeker,
      message_type: Messages::Types::Person::START_ONBOARDING,
      version: 1
    )
    V2 = Messages::Schema.active(
      type: Messages::COMMAND,
      data: Messages::Nothing,
      metadata: Messages::Nothing,
      stream: Streams::Person,
      message_type: Messages::Types::Person::START_ONBOARDING,
      version: 2
    )
  end
end
