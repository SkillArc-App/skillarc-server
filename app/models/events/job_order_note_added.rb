module Events
  module JobOrderNoteAdded
    module Data
      class V1
        extend Messages::Payload

        schema do
          originator String
          note_id Uuid
          note String
        end
      end
    end

    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      stream: Streams::JobOrder,
      message_type: Messages::Types::JobOrders::JOB_ORDER_NOTE_ADDED,
      version: 1
    )
  end
end
