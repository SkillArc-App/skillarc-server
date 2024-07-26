module JobOrders
  module Events
    module ClosedNotFilled
      V1 = Core::Schema.active(
        type: Core::EVENT,
        data: Core::Nothing,
        metadata: Core::Nothing,
        stream: Streams::JobOrder,
        message_type: MessageTypes::CLOSED_NOT_FILLED,
        version: 1
      )
    end
  end
end
