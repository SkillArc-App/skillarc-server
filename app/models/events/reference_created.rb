module Events
  module ReferenceCreated
    module Data
      class V1
        extend Messages::Payload

        schema do
          author_training_provider_profile_id Uuid
          reference_text String
          seeker_id Uuid
        end
      end
    end

    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Reference,
      message_type: Messages::Types::TrainingProviders::REFERENCE_CREATED,
      version: 1
    )
  end
end
