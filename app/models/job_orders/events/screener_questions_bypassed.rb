module JobOrders
  module Events
    module ScreenerQuestionsBypassed
      V1 = Core::Schema.active(
        type: Core::COMMAND,
        data: Core::Nothing,
        metadata: Core::Nothing,
        stream: Streams::JobOrder,
        message_type: MessageTypes::SCREENER_QUESTIONS_BYPASSED,
        version: 1
      )
    end
  end
end
