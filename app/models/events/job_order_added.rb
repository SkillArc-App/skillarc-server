module Events
  module JobOrderAdded
    module Data
      class V1
        extend Messages::Payload

        schema do
          job_id Uuid
        end
      end
    end

    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      stream: Streams::JobOrder,
      message_type: Messages::Types::JobOrders::JOB_ORDER_ADDED,
      version: 1
    )
  end
end
