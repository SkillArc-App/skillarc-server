module Events
  module TrainingProviderInviteAccepted
    V1 = Messages::Schema.build(
      data: Messages::UntypedHashWrapper,
      metadata: Messages::Nothing,
      message_type: Messages::Types::TRAINING_PROVIDER_INVITE_ACCEPTED,
      version: 1
    )
  end
end
