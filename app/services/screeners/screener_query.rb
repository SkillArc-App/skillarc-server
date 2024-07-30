module Screeners
  class ScreenerQuery
    def self.all_questions
      Questions.all.map { |q| serialize_questions(q) }
    end

    def self.find_questions(id)
      serialize_questions(Questions.find(id))
    end

    def self.all_answers(person_id)
      answers_sets = Answers.all
      answers_sets = answers_sets.where(person_id:) if person_id.present?

      answers_sets.map { |answers| serialize_answers(answers) }
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
          questions: questions.questions,
          created_at: questions.created_at
        }
      end

      def serialize_answers(answers)
        {
          id: answers.id,
          title: answers.title,
          person_id: answers.person_id,
          screener_questions_id: answers.screeners_questions_id,
          question_responses: answers.question_responses,
          created_at: answers.created_at
        }
      end
    end
  end
end
