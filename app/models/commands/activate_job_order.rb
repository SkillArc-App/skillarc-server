module Commands
  module ActivateJobOrder
    V1 = Core::Schema.active(
      type: Core::COMMAND,
      data: Core::Nothing,
      metadata: Core::Nothing,
      aggregate: Aggregates::JobOrder,
      message_type: MessageTypes::JobOrders::ACTIVATE_JOB_ORDER,
      version: 1
    )
  end
end
