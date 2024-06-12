module Events
  module OnboardingCompleted
    module Data
      class V1
        extend Messages::Payload

        schema do
          name Either(Hash, nil), default: nil
          experience Either(Hash, nil), default: nil
          education Either(Hash, nil), default: nil
          trainingProvider Either(Hash, nil), default: nil
          other Either(Hash, nil), default: nil
          opportunityInterests Either(Hash, nil), default: nil
        end
      end
    end

    V1 = Messages::Schema.destroy!(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      stream: Streams::User,
      message_type: Messages::Types::Person::ONBOARDING_COMPLETED,
      version: 1
    )
    V2 = Messages::Schema.inactive(
      type: Messages::EVENT,
      data: Messages::Nothing,
      metadata: Messages::Nothing,
      stream: Streams::Seeker,
      message_type: Messages::Types::Person::ONBOARDING_COMPLETED,
      version: 2
    )
    V3 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Messages::Nothing,
      metadata: Messages::Nothing,
      stream: Streams::Person,
      message_type: Messages::Types::Person::ONBOARDING_COMPLETED,
      version: 3
    )
  end
end
