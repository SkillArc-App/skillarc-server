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

    V1 = Messages::Schema.inactive(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::User,
      message_type: Messages::Types::Seekers::ONBOARDING_COMPLETED,
      version: 1
    )
    V2 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Messages::Nothing,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Seeker,
      message_type: Messages::Types::Seekers::ONBOARDING_COMPLETED,
      version: 2
    )
  end
end
