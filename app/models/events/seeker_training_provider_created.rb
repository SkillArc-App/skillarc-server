module Events
  module SeekerTrainingProviderCreated
    V1 = Schema.new(
      data: Common::UntypedHashWrapper,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::SEEKER_TRAINING_PROVIDER_CREATED,
      version: 1
    )
  end
end
