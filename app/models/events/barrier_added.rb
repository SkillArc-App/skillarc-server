module Events
  module BarrierAdded
    V1 = Schema.build(
      data: Common::UntypedHashWrapper,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::BARRIER_ADDED,
      version: 1
    )
  end
end
