module Events
  module SmsMessageSent
    module Data
      class V1
        extend Messages::Payload

        schema do
          phone_number String
          message String
        end
      end
    end

    V1 = Messages::Schema.destroy!(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Phone,
      message_type: Messages::Types::Contact::SMS_MESSAGE_SENT,
      version: 1
    )
    V2 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Message,
      message_type: Messages::Types::Contact::SMS_MESSAGE_SENT,
      version: 2
    )
  end
end
