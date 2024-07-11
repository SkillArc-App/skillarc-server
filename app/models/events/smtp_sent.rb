module Events
  module SmtpSent
    module Data
      class V1
        extend Core::Payload

        schema do
          email String
          template String
          template_data Hash
        end
      end
    end

    V1 = Core::Schema.active(
      type: Core::EVENT,
      data: Data::V1,
      metadata: Core::Nothing,
      aggregate: Streams::Contact,
      message_type: MessageTypes::Contact::SMTP_SENT,
      version: 1
    )
  end
end
