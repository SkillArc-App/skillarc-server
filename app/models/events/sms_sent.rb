module Events
  module SmsSent
    module Data
      class V1
        extend Payload

        schema do
          phone_number String
          message String
        end
      end
    end

    V1 = Schema.build(
      data: Data::V1,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::SMS_SENT,
      version: 1
    )
  end
end
