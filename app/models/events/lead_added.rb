module Events
  module LeadAdded
    V1 = Schema.new(
      data: Common::UntypedHashWrapper,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::LEAD_ADDED,
      version: 1
    )
  end
end
