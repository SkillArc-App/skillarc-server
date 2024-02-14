module Events
  module SmtpSent
    module Data
      class V1
        extend Payload

        schema do
          email String
          template String
          template_data Hash
        end
      end
    end

    V1 = Schema.build(
      data: Data::V1,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::SMTP_SENT,
      version: 1
    )
  end
end
