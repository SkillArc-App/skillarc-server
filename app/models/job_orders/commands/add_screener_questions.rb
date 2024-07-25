module JobOrders
  module Commands
    module AddScreenerQuestions
      module Data
        class V1
          extend Core::Payload

          schema do
            screener_questions_id Uuid
          end
        end
      end

      V1 = Core::Schema.active(
        type: Core::COMMAND,
        data: Data::V1,
        metadata: Core::Nothing,
        stream: Streams::JobOrder,
        message_type: MessageTypes::ADD_SCREENER_QUESTIONS,
        version: 1
      )
    end
  end
end
