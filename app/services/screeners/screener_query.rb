module Screeners
  class ScreenerQuery
    def self.find_questions(id)
      serialize_questions(Questions.find(id))
    end

    def self.find_answers(id)
      serialize_answers(Answers.find(id))
    end

    class << self
      private

      def serialize_questions(questions)
        {
          id: questions.id,
          title: questions.title,
          questions: questions.questions
        }
      end

      def serialize_answers(answers)
        {
          id: answers.id,
          title: answers.title,
          screener_questions_id: answers.screeners_questions_id,
          question_responses: answers.question_responses
        }
      end
    end
  end
end
