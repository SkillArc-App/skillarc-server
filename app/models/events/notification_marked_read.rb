module Events
  module NotificationMarkedRead
    V1 = Schema.new(
      data: Common::UntypedHashWrapper,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::NOTIFICATIONS_MARKED_READ,
      version: 1
    )
  end
end
