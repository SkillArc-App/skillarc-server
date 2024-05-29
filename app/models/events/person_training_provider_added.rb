module Events
  module PersonTrainingProviderAdded
    module Data
      class V1
        extend Messages::Payload

        schema do
          id Uuid
          status String
          program_id Either(String, nil)
          training_provider_id Uuid
        end
      end
    end

    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Person,
      message_type: Messages::Types::Person::PERSON_TRAINING_PROVIDER_ADDED,
      version: 1
    )
  end
end
