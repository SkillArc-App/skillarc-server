module Events
  module TrainingProviderInviteAccepted
    V1 = Schema.new(
      data: Common::UntypedHashWrapper,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::TRAINING_PROVIDER_INVITE_ACCEPTED,
      version: 1
    )
  end
end
