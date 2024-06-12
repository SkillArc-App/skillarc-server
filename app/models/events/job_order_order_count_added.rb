module Events
  module JobOrderOrderCountAdded
    module Data
      class V1
        extend Messages::Payload

        schema do
          order_count 1..
        end
      end
    end

    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      stream: Streams::JobOrder,
      message_type: Messages::Types::JobOrders::JOB_ORDER_ORDER_COUNT_ADDED,
      version: 1
    )
  end
end
