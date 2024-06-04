module Commands
  module SendMessage
    module Data
      class V1
        extend Messages::Payload

        schema do
          user_id String
          title String
          body String
          url Either(String, nil)
        end
      end

      class V2
        extend Messages::Payload

        schema do
          person_id Uuid
          title String
          body String
          url Either(String, nil)
        end
      end
    end

    module MetaData
      class V1
        extend Messages::Payload

        schema do
          requestor_type Either(*Requestor::Kinds::ALL, nil), default: nil
          requestor_id Either(String, nil), default: nil
        end
      end
    end

    V1 = Messages::Schema.inactive(
      type: Messages::COMMAND,
      data: Data::V1,
      metadata: MetaData::V1,
      aggregate: Aggregates::Message,
      message_type: Messages::Types::Contact::SEND_MESSAGE,
      version: 1
    )
    V2 = Messages::Schema.active(
      type: Messages::COMMAND,
      data: Data::V2,
      metadata: MetaData::V1,
      aggregate: Aggregates::Message,
      message_type: Messages::Types::Contact::SEND_MESSAGE,
      version: 2
    )
  end
end
