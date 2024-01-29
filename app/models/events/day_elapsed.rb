module Events
  module DayElapsed
    V1 = Schema.build(
      data: Common::Nothing,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::DAY_ELAPSED,
      version: 1
    )
  end
end
