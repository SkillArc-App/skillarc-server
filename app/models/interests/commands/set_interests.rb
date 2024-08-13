module Interests
  module Commands
    module SetInterests
      module Data
        class V1
          extend Core::Payload

          schema do
            interests ArrayOf(String)
          end
        end
      end

      V1 = Core::Schema.active(
        type: Core::COMMAND,
        data: Data::V1,
        metadata: Core::Nothing,
        stream: Streams::Interest,
        message_type: MessageTypes::SET_INTERESTS,
        version: 1
      )
    end
  end
end
