module Events
  module JobOrderNotFilled
    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Messages::Nothing,
      metadata: Messages::Nothing,
      stream: Streams::JobOrder,
      message_type: Messages::Types::JobOrders::JOB_ORDER_NOT_FILLED,
      version: 1
    )
  end
end
