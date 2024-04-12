module Commands
  module SendSms
    module Data
      class V1
        extend Messages::Payload

        schema do
          phone_number String
          message String
        end
      end
    end

    V1 = Messages::Schema.deprecated(
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Seeker,
      message_type: Messages::Types::Contact::SEND_SMS,
      version: 1
    )
    V2 = Messages::Schema.active(
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Phone,
      message_type: Messages::Types::Contact::SEND_SMS,
      version: 2
    )
  end
end
