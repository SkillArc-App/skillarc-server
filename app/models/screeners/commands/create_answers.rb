module Screeners
  module Commands
    module CreateAnswers
      module Data
        class V1
          extend Core::Payload

          schema do
            title String
            screener_questions_id Uuid
            question_responses ArrayOf(QuestionResponse)
          end
        end
      end

      V1 = Core::Schema.active(
        type: Core::COMMAND,
        data: Data::V1,
        metadata: Core::RequestorMetadata::V2,
        stream: Streams::Answers,
        message_type: MessageTypes::CREATE_SCREENER_ANSWERS,
        version: 1
      )
    end
  end
end
