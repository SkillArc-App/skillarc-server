module Events
  module JobUpdated
    V1 = Schema.new(
      data: Common::UntypedHashWrapper,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::COACH_ASSIGNED,
      version: 1
    )
  end
end
