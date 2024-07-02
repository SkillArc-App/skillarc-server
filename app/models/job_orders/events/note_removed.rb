module JobOrders
  module Events
    module NoteRemoved
      module Data
        class V1
          extend Core::Payload

          schema do
            originator String
            note_id Uuid
          end
        end
      end

      V1 = Core::Schema.active(
        type: Core::EVENT,
        data: Data::V1,
        metadata: Core::Nothing,
        aggregate: Aggregates::JobOrder,
        message_type: MessageTypes::JOB_ORDER_NOTE_REMOVED,
        version: 1
      )
    end
  end
end
