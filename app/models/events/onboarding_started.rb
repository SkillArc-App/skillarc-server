module Events
  module OnboardingStarted
    module Data
      class V1
        extend Core::Payload

        schema do
          user_id String
        end
      end
    end

    V1 = Core::Schema.inactive(
      type: Core::EVENT,
      data: Data::V1,
      metadata: Core::Nothing,
      aggregate: Streams::Seeker,
      message_type: MessageTypes::Person::ONBOARDING_STARTED,
      version: 1
    )
    V2 = Core::Schema.active(
      type: Core::EVENT,
      data: Core::Nothing,
      metadata: Core::Nothing,
      aggregate: Streams::Person,
      message_type: MessageTypes::Person::ONBOARDING_STARTED,
      version: 2
    )
  end
end
