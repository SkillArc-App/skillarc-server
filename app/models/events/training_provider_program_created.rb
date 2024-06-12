module Events
  module TrainingProviderProgramCreated
    module Data
      class V1
        extend Messages::Payload

        schema do
          program_id Uuid
          name String
          description String
        end
      end
    end

    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      stream: Streams::TrainingProvider,
      message_type: Messages::Types::TrainingProviders::TRAINING_PROVIDER_PROGRAM_CREATED,
      version: 1
    )
  end
end
