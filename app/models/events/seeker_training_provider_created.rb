module Events
  module SeekerTrainingProviderCreated
    module Data
      class V1
        extend Messages::Payload

        schema do
          id Uuid
          user_id String
          training_provider_id Uuid
        end
      end
    end

    V1 = Messages::Schema.inactive(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::User,
      message_type: Messages::Types::SEEKER_TRAINING_PROVIDER_CREATED,
      version: 1
    )
    V2 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Seeker,
      message_type: Messages::Types::SEEKER_TRAINING_PROVIDER_CREATED,
      version: 2
    )
  end
end
