module Commands
  module SendSmsMessage
    module Data
      class V1
        extend Messages::Payload

        schema do
          phone_number String
          message String
        end
      end
    end

    V1 = Messages::Schema.inactive(
      type: Messages::COMMAND,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Seeker,
      message_type: Messages::Types::Contact::SEND_SMS_MESSAGE,
      version: 1
    )
    V2 = Messages::Schema.inactive(
      type: Messages::COMMAND,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Phone,
      message_type: Messages::Types::Contact::SEND_SMS_MESSAGE,
      version: 2
    )
    V3 = Messages::Schema.active(
      type: Messages::COMMAND,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Message,
      message_type: Messages::Types::Contact::SEND_SMS_MESSAGE,
      version: 3
    )
  end
end
