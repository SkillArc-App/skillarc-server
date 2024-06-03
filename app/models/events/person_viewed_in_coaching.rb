module Events
  module PersonViewedInCoaching
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
      aggregate: Aggregates::Coach,
      message_type: Messages::Types::Coaches::PERSON_VIEWED_IN_COACHING,
      version: 1
    )
  end
end
