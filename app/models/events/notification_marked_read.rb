module Events
  module NotificationMarkedRead
    V1 = Messages::Schema.build(
      data: Messages::UntypedHashWrapper,
      metadata: Messages::Nothing,
      event_type: Event::EventTypes::NOTIFICATIONS_MARKED_READ,
      version: 1
    )
  end
end
