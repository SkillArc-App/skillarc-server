module Events
  module BarrierUpdated
    V1 = Schema.build(
      data: Common::UntypedHashWrapper,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::BARRIERS_UPDATED,
      version: 1
    )
  end
end
