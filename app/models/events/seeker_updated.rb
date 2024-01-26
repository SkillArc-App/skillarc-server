module Events
  module SeekerUpdated
    V1 = Schema.new(
      data: Common::UntypedHashWrapper,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::SEEKER_UPDATED,
      version: 1
    )
  end
end
