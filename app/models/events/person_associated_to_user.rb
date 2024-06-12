module Events
  module PersonAssociatedToUser
    module Data
      class V1
        extend Messages::Payload

        schema do
          user_id String
        end
      end
    end

    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      stream: Streams::Person,
      message_type: Messages::Types::Person::PERSON_ASSOCIATED_TO_USER,
      version: 1
    )
  end
end
