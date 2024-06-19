module Events
  module TrainingProviderCreated
    module Data
      class V1
        extend Core::Payload

        schema do
          name String
          description String
        end
      end
    end

    V1 = Core::Schema.active(
      type: Core::EVENT,
      data: Data::V1,
      metadata: Core::Nothing,
      aggregate: Aggregates::TrainingProvider,
      message_type: MessageTypes::TrainingProviders::TRAINING_PROVIDER_CREATED,
      version: 1
    )
  end
end
