module Events
  module SeekerTrainingProviderCreated
    V1 = Messages::Schema.build(
      data: Messages::UntypedHashWrapper,
      metadata: Messages::Nothing,
      message_type: Messages::Types::SEEKER_TRAINING_PROVIDER_CREATED,
      version: 1
    )
  end
end
