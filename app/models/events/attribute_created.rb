module Events
  module AttributeCreated
    module Data
      class V1
        extend Core::Payload

        schema do
          name String
          description String
          set ArrayOf(String)
          default ArrayOf(String)
        end
      end
    end

    V1 = Core::Schema.active(
      type: Core::EVENT,
      data: Data::V1,
      metadata: Core::Nothing,
      aggregate: Aggregates::Attribute,
      message_type: MessageTypes::Attributes::ATTRIBUTE_CREATED,
      version: 1
    )
  end
end
