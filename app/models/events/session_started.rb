module Events
  module SessionStarted
    V1 = Schema.build(
      data: Common::Nothing,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::SESSION_STARTED,
      version: 1
    )
  end
end
