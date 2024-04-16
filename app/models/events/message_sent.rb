module Events
  module MessageSent
    module Data
      class V1
        extend Messages::Payload

        schema do
          user_id String
          title String
          body String
          url String
        end
      end
    end

    module MetaData
      class V1
        extend Messages::Payload

        schema do
          requestor_type Either(*Requestor::Kinds::ALL)
          requestor_id Either(String, nil)
        end
      end
    end

    V1 = Messages::Schema.active(
      data: Data::V1,
      metadata: MetaData::V1,
      aggregate: Aggregates::Message,
      message_type: Messages::Types::Contact::MESSAGE_SENT,
      version: 1
    )
  end
end
