module Events
  module SmsSent
    module Data
      class V1
        extend Messages::Payload

        schema do
          phone_number String
          message String
        end
      end
    end

    V1 = Messages::Schema.build(
      data: Data::V1,
      metadata: Messages::Nothing,
      event_type: Messages::Types::Contact::SMS_SENT,
      version: 1
    )
  end
end
