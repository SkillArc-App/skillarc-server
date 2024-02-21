module Events
  module SessionStarted
    V1 = Messages::Schema.build(
      data: Messages::Nothing,
      metadata: Messages::Nothing,
      event_type: Event::EventTypes::SESSION_STARTED,
      version: 1
    )
  end
end
