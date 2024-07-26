module JobOrders
  module Commands
    module CloseAsNotFilled
      V1 = Core::Schema.active(
        type: Core::COMMAND,
        data: Core::Nothing,
        metadata: Core::Nothing,
        stream: Streams::JobOrder,
        message_type: MessageTypes::CLOSE_AS_NOT_FILLED,
        version: 1
      )
    end
  end
end
