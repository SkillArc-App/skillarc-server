module Users
  module Events
    module BarrierAdded
      module Data
        class V1
          extend Core::Payload

          schema do
            barrier_id Uuid
            name String
          end
        end
      end

      V1 = Core::Schema.inactive(
        type: Core::EVENT,
        data: Data::V1,
        metadata: Core::Nothing,
        stream: Streams::User,
        message_type: MessageTypes::BARRIER_ADDED,
        version: 1
      )
    end
  end
end
