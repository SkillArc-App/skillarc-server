module Events
  module NotificationCreated
    V1 = Schema.build(
      data: Common::UntypedHashWrapper,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::NOTIFICATION_CREATED,
      version: 1
    )
  end
end
