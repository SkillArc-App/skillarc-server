module Events
  module LeadAdded
    V1 = Schema.build(
      data: Common::UntypedHashWrapper,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::LEAD_ADDED,
      version: 1
    )
  end
end
