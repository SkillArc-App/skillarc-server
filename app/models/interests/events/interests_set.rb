module Interests
  module Events
    module InterestsSet
      module Data
        class V1
          extend Core::Payload

          schema do
            interests ArrayOf(String)
          end
        end
      end

      V1 = Core::Schema.active(
        type: Core::EVENT,
        data: Data::V1,
        metadata: Core::Nothing,
        stream: Streams::Interest,
        message_type: MessageTypes::INTERESTS_SET,
        version: 1
      )
    end
  end
end
