module JobOrders
  module Events
    module ScreenerQuestionsAdded
      module Data
        class V1
          extend Core::Payload

          schema do
            screener_questions_id Uuid
          end
        end
      end

      V1 = Core::Schema.active(
        type: Core::EVENT,
        data: Data::V1,
        metadata: Core::Nothing,
        stream: Streams::JobOrder,
        message_type: MessageTypes::SCREENER_QUESTIONS_ADDED,
        version: 1
      )
    end
  end
end
