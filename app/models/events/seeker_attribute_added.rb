module Events
  module SeekerAttributeAdded
    module Data
      class V1
        extend Messages::Payload

        schema do
          id Uuid
          attribute_id Uuid
          attribute_name String
          attribute_values ArrayOf(String)
        end
      end
    end

    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Seeker,
      message_type: Messages::Types::Seekers::SEEKER_ATTRIBUTE_ADDED,
      version: 1
    )
  end
end
