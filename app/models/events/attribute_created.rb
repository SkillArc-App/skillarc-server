module Events
  module AttributeCreated
    module Data
      class V1
        extend Messages::Payload

        schema do
          name String
          set ArrayOf(String)
          default ArrayOf(String)
        end
      end
    end

    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Attribute,
      message_type: Messages::Types::Attributes::ATTRIBUTE_CREATED,
      version: 1
    )
  end
end
