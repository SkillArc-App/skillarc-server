module Events
  module JobOrderNoteModified
    module Data
      class V1
        extend Core::Payload

        schema do
          originator String
          note_id Uuid
          note String
        end
      end
    end

    V1 = Core::Schema.active(
      type: Core::EVENT,
      data: Data::V1,
      metadata: Core::Nothing,
      aggregate: Aggregates::JobOrder,
      message_type: MessageTypes::JobOrders::JOB_ORDER_NOTE_MODIFIED,
      version: 1
    )
  end
end
