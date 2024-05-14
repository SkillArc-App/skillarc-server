module Commands
  module ActivateJobOrder
    V1 = Messages::Schema.active(
      type: Messages::COMMAND,
      data: Messages::Nothing,
      metadata: Messages::Nothing,
      aggregate: Aggregates::JobOrder,
      message_type: Messages::Types::JobOrders::ACTIVATE_JOB_ORDER,
      version: 1
    )
  end
end
