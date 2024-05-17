module Events
  module JobOrderNoteRemoved
    module Data
      class V1
        extend Messages::Payload

        schema do
          originator String
          note_id Uuid
        end
      end
    end

    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::JobOrder,
      message_type: Messages::Types::JobOrders::JOB_ORDER_NOTE_REMOVED,
      version: 1
    )
  end
end
