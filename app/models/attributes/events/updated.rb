module Attributes
  module Events
    module Updated
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

      V1 = Core::Schema.inactive(
        type: Core::EVENT,
        data: Data::V1,
        metadata: Core::Nothing,
        stream: Streams::Attribute,
        message_type: MessageTypes::ATTRIBUTE_UPDATED,
        version: 1
      )
      V2 = Core::Schema.active(
        type: Core::EVENT,
        data: Data::V1,
        metadata: Core::RequestorMetadata::V1,
        stream: Streams::Attribute,
        message_type: MessageTypes::ATTRIBUTE_UPDATED,
        version: 2
      )
    end
  end
end
