module JobOrders
  module Events
    module Reactivated
      V1 = Core::Schema.active(
        type: Core::EVENT,
        data: Core::Nothing,
        metadata: Core::Nothing,
        stream: Streams::JobOrder,
        message_type: MessageTypes::REACTIVATED,
        version: 1
      )
    end
  end
end
