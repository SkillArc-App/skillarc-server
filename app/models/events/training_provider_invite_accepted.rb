module Events
  module TrainingProviderInviteAccepted
    V1 = Messages::Schema.build(
      data: Messages::UntypedHashWrapper,
      metadata: Messages::Nothing,
      event_type: Event::EventTypes::TRAINING_PROVIDER_INVITE_ACCEPTED,
      version: 1
    )
  end
end
