module Events
  module OnboardingCompleted
    module Data
      class V1
        extend Messages::Payload

        schema do
          name Hash
          experience Either(Hash, nil), default: nil
          education Either(Hash, nil), default: nil
          trainingProvider Either(Hash, nil), default: nil
          other Either(Hash, nil), default: nil
          opportunityInterests Either(Hash, nil), default: nil
        end
      end
    end

    V1 = Messages::Schema.build(
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::User,
      message_type: Messages::Types::Seekers::ONBOARDING_COMPLETED,
      version: 1
    )
  end
end
