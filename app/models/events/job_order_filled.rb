module Events
  module JobOrderFilled
    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Messages::Nothing,
      metadata: Messages::Nothing,
      aggregate: Aggregates::JobOrder,
      message_type: Messages::Types::JobOrders::JOB_ORDER_FILLED,
      version: 1
    )
  end
end
