module Events
  module SmtpSent
    module Data
      class V1
        extend Messages::Payload

        schema do
          email String
          template String
          template_data Hash
        end
      end
    end

    V1 = Messages::Schema.build(
      data: Data::V1,
      metadata: Messages::Nothing,
      message_type: Messages::Types::Contact::SMTP_SENT,
      version: 1
    )
  end
end
