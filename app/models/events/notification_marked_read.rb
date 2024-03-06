module Events
  module NotificationMarkedRead
    module Data
      class V1
        extend Messages::Payload

        schema do
          notification_id Integer
        end
      end
    end

    V1 = Messages::Schema.build(
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::User,
      message_type: Messages::Types::NOTIFICATIONS_MARKED_READ,
      version: 1
    )
  end
end
