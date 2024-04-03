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
    end

    V1 = Messages::Schema.active(
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::User,
      message_type: Messages::Types::NOTIFICATION_CREATED,
      version: 1
    )
  end
end
