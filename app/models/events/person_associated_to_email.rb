module Events
  module PersonAssociatedToEmail
    module Data
      class V1
        extend Messages::Payload

        schema do
          person_id Uuid
        end
      end
    end

    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      stream: Streams::Email,
      message_type: Messages::Types::Email::PERSON_ASSOCIATED_TO_EMAIL,
      version: 1
    )
  end
end
