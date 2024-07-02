module JobOrders
  module Events
    module Filled
      V1 = Core::Schema.active(
        type: Core::EVENT,
        data: Core::Nothing,
        metadata: Core::Nothing,
        aggregate: Aggregates::JobOrder,
        message_type: MessageTypes::JOB_ORDER_FILLED,
        version: 1
      )
    end
  end
end
