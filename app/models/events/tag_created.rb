module Events
  module TagCreated
    module Data
      class V1
        extend Messages::Payload

        schema do
          name String
        end
      end
    end

    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Tag,
      message_type: Messages::Types::Tags::TAG_CREATED,
      version: 1
    )
  end
end
