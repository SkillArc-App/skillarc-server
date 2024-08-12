module Attributes
  module Commands
    module Update
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
        type: Core::COMMAND,
        data: Data::V1,
        metadata: Core::Nothing,
        stream: Streams::Attribute,
        message_type: MessageTypes::UPDATE_ATTRIBUTE,
        version: 1
      )
    end
  end
end

