module Commands
  module UpdateTrainingProviderProgram
    module Data
      class V1
        extend Core::Payload

        schema do
          program_id Uuid
          name String
          description String
        end
      end
    end

    V1 = Core::Schema.active(
      type: Core::COMMAND,
      data: Data::V1,
      metadata: Core::Nothing,
      aggregate: Aggregates::TrainingProvider,
      message_type: MessageTypes::TrainingProviders::UPDATE_TRAINING_PROVIDER_PROGRAM,
      version: 1
    )
  end
end
