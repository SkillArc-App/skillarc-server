module Events
  module TrainingProviderCreated
    module Data
      class V1
        extend Messages::Payload

        schema do
          name String
          description String
        end
      end
    end

    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::TrainingProvider,
      message_type: Messages::Types::TrainingProviders::TRAINING_PROVIDER_CREATED,
      version: 1
    )
  end
end
