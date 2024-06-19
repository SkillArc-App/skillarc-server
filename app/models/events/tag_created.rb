module Events
  module TagCreated
    module Data
      class V1
        extend Core::Payload

        schema do
          name String
        end
      end
    end

    V1 = Core::Schema.active(
      type: Core::EVENT,
      data: Data::V1,
      metadata: Core::Nothing,
      aggregate: Aggregates::Tag,
      message_type: MessageTypes::Tags::TAG_CREATED,
      version: 1
    )
  end
end
