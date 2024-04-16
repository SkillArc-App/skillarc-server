module Events
  module NotificationCreated
    module Data
      class V1
        extend Messages::Payload

        schema do
          title String
          body String
          url String
        end
      end

      class V2
        extend Messages::Payload

        schema do
          title String
          body String
          url String
          notification_id Uuid
        end
      end

      class V3
        extend Messages::Payload

        schema do
          title String
          body String
          url String
          user_id String
          notification_id Uuid
        end
      end
    end

    V1 = Messages::Schema.deprecated(
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::User,
      message_type: Messages::Types::NOTIFICATION_CREATED,
      version: 1
    )
    V2 = Messages::Schema.deprecated(
      data: Data::V2,
      metadata: Messages::Nothing,
      aggregate: Aggregates::User,
      message_type: Messages::Types::NOTIFICATION_CREATED,
      version: 2
    )
    V3 = Messages::Schema.active(
      data: Data::V3,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Message,
      message_type: Messages::Types::NOTIFICATION_CREATED,
      version: 3
    )
  end
end
