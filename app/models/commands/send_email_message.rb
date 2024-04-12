module Commands
  module SendEmailMessage
    module Data
      class V1
        extend Messages::Payload

        schema do
          recepent_email String
          title String
          body String
          url Either(String, nil)
        end
      end
    end

    V1 = Messages::Schema.active(
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Message,
      message_type: Messages::Types::Contact::SEND_EMAIL_MESSAGE,
      version: 1
    )
  end
end
