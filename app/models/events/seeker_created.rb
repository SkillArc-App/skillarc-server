module Events
  module SeekerCreated
    V1 = Schema.build(
      data: Common::UntypedHashWrapper,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::SEEKER_CREATED,
      version: 1
    )
  end
end
