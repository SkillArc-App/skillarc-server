module Events
  module SeekerAttributeRemoved
    module Data
      class V1
        extend Messages::Payload

        schema do
          id Uuid
        end
      end
    end

    V1 = Messages::Schema.deprecated(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Seeker,
      message_type: Messages::Types::Seekers::SEEKER_ATTRIBUTE_REMOVED,
      version: 1
    )
  end
end
