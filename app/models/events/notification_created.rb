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
    end

    V1 = Messages::Schema.deprecated(
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::User,
      message_type: Messages::Types::NOTIFICATION_CREATED,
      version: 1
    )
    V2 = Messages::Schema.active(
      data: Data::V2,
      metadata: Messages::Nothing,
      aggregate: Aggregates::User,
      message_type: Messages::Types::NOTIFICATION_CREATED,
      version: 2
    )
  end
end
