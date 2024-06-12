module Events
  module NotificationMarkedRead
    module Data
      class V1
        extend Messages::Payload

        schema do
          notification_id Integer
        end
      end

      class V2
        extend Messages::Payload

        schema do
          notification_ids ArrayOf(Uuid)
        end
      end
    end

    V1 = Messages::Schema.destroy!(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      stream: Streams::User,
      message_type: Messages::Types::NOTIFICATIONS_MARKED_READ,
      version: 1
    )
    V2 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V2,
      metadata: Messages::Nothing,
      stream: Streams::User,
      message_type: Messages::Types::NOTIFICATIONS_MARKED_READ,
      version: 2
    )
  end
end
