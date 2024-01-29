module Events
  module TrainingProviderInviteAccepted
    V1 = Schema.build(
      data: Common::UntypedHashWrapper,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::TRAINING_PROVIDER_INVITE_ACCEPTED,
      version: 1
    )
  end
end
