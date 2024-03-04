module Events
  module ReasonCreated
    module Data
      class V1
        extend Messages::Payload

        schema do
          id Uuid
          description String
        end
      end
    end

    V1 = Messages::Schema.build(
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::User,
      message_type: Messages::Types::REASON_CREATED,
      version: 1
    )
  end
end
