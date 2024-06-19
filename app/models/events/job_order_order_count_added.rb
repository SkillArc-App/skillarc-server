module Events
  module JobOrderOrderCountAdded
    module Data
      class V1
        extend Core::Payload

        schema do
          order_count 1..
        end
      end
    end

    V1 = Core::Schema.active(
      type: Core::EVENT,
      data: Data::V1,
      metadata: Core::Nothing,
      aggregate: Aggregates::JobOrder,
      message_type: MessageTypes::JobOrders::JOB_ORDER_ORDER_COUNT_ADDED,
      version: 1
    )
  end
end
