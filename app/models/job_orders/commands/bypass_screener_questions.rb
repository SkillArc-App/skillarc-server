module JobOrders
  module Commands
    module BypassScreenerQuestions
      V1 = Core::Schema.active(
        type: Core::COMMAND,
        data: Core::Nothing,
        metadata: Core::Nothing,
        stream: Streams::JobOrder,
        message_type: MessageTypes::BYPASS_SCREENER_QUESTIONS,
        version: 1
      )
    end
  end
end
