module Events
  module PersonAssociatedToUser
    module Data
      class V1
        extend Core::Payload

        schema do
          user_id String
        end
      end
    end

    V1 = Core::Schema.active(
      type: Core::EVENT,
      data: Data::V1,
      metadata: Core::Nothing,
      aggregate: Aggregates::Person,
      message_type: MessageTypes::Person::PERSON_ASSOCIATED_TO_USER,
      version: 1
    )
  end
end
