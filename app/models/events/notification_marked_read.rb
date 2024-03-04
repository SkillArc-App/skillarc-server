module Events
  module NotificationMarkedRead
    V1 = Messages::Schema.build(
      data: Messages::UntypedHashWrapper,
      metadata: Messages::Nothing,
      aggregate: Aggregates::User,
      message_type: Messages::Types::NOTIFICATIONS_MARKED_READ,
      version: 1
    )
  end
end
