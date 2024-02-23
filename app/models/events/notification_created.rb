module Events
  module NotificationCreated
    V1 = Messages::Schema.build(
      data: Messages::UntypedHashWrapper,
      metadata: Messages::Nothing,
      event_type: Messages::Types::NOTIFICATION_CREATED,
      version: 1
    )
  end
end
