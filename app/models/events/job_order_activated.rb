module Events
  module JobOrderActivated
    V1 = Core::Schema.active(
      type: Core::EVENT,
      data: Core::Nothing,
      metadata: Core::Nothing,
      aggregate: Aggregates::JobOrder,
      message_type: MessageTypes::JobOrders::JOB_ORDER_ACTIVATED,
      version: 1
    )
  end
end
