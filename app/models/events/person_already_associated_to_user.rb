module Events
  module PersonAlreadyAssociatedToUser
    module Data
      class V1
        extend Messages::Payload

        schema do
          user_id Uuid
        end
      end
    end

    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Person,
      message_type: Messages::Types::Person::PERSON_ALREADY_ASSOCIATED_TO_USER,
      version: 1
    )
  end
end
