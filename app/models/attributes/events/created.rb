module Attributes
  module Events
    module Created
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

        class V2
          extend Core::Payload

          schema do
            machine_derived Bool()
            name String
            description String
            set ArrayOf(String)
            default ArrayOf(String)
          end
        end

        class V3
          extend Core::Payload

          schema do
            machine_derived Bool()
            name String
            description String
            set ArrayOf(Core::UuidKeyValuePair)
            default ArrayOf(Core::UuidKeyValuePair)
          end
        end
      end

      V1 = Core::Schema.inactive(
        type: Core::EVENT,
        data: Data::V1,
        metadata: Core::Nothing,
        stream: Streams::Attribute,
        message_type: MessageTypes::ATTRIBUTE_CREATED,
        version: 1
      )
      V2 = Core::Schema.inactive(
        type: Core::EVENT,
        data: Data::V2,
        metadata: Core::Nothing,
        stream: Streams::Attribute,
        message_type: MessageTypes::ATTRIBUTE_CREATED,
        version: 2
      )
      V3 = Core::Schema.inactive(
        type: Core::EVENT,
        data: Data::V2,
        metadata: Core::RequestorMetadata::V1,
        stream: Streams::Attribute,
        message_type: MessageTypes::ATTRIBUTE_CREATED,
        version: 3
      )
      V4 = Core::Schema.active(
        type: Core::EVENT,
        data: Data::V3,
        metadata: Core::RequestorMetadata::V1,
        stream: Streams::Attribute,
        message_type: MessageTypes::ATTRIBUTE_CREATED,
        version: 4
      )
    end
  end
end
