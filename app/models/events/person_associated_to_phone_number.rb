module Events
  module PersonAssociatedToPhoneNumber
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
      aggregate: Aggregates::Phone,
      message_type: Messages::Types::Phone::PERSON_ASSOCIATED_TO_PHONE_NUMBER,
      version: 1
    )
  end
end
