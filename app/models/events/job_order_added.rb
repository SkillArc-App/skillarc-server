module Events
  module JobOrderAdded
    module Data
      class V1
        extend Messages::Payload

        schema do
          job_id Uuid
          order_count Either(1.., nil), default: nil
        end
      end
    end

    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::JobOrder,
      message_type: Messages::Types::JobOrders::JOB_ORDER_ADDED,
      version: 1
    )
  end
end
