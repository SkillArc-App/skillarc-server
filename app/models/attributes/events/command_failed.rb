module Attributes
  module Events
    module CommandFailed
      module Data
        class V1
          extend Core::Payload

          schema do
            reason String
          end
        end
      end

      V1 = Core::Schema.active(
        type: Core::EVENT,
        data: Data::V1,
        metadata: Core::RequestorMetadata::V1,
        stream: Streams::Attribute,
        message_type: MessageTypes::ATTRIBUTE_COMMAND_FAILED,
        version: 1
      )
    end
  end
end
