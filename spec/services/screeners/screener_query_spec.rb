require 'rails_helper'

RSpec.describe Screeners::ScreenerQuery do
  describe ".all_questions" do
    subject { described_class.all_questions }

    let!(:questions1) { create(:screeners__questions) }
    let!(:questions2) { create(:screeners__questions) }

    let(:serialized_question1) do
      {
        id: questions1.id,
        title: questions1.title,
        questions: questions1.questions,
        created_at: questions1.created_at
      }
    end
    let(:serialized_question2) do
      {
        id: questions2.id,
        title: questions2.title,
        questions: questions2.questions,
        created_at: questions2.created_at
      }
    end

    it "returns the questions" do
      expect(subject).to contain_exactly(serialized_question1, serialized_question2)
    end
  end

  describe ".all_answers" do
    subject { described_class.all_answers(person_id) }

    let!(:answers1) { create(:screeners__answers, person_id: id) }
    let!(:answers2) { create(:screeners__answers) }

    let(:id) { SecureRandom.uuid }

    let(:serialized_answers1) do
      {
        id: answers1.id,
        title: answers1.title,
        person_id: answers1.person_id,
        documents_screeners_id: answers1.documents_screeners_id,
        document_status: answers1.document_status,
        screener_questions_id: answers1.screeners_questions_id,
        question_responses: answers1.question_responses,
        created_at: answers1.created_at
      }
    end
    let(:serialized_answers2) do
      {
        id: answers2.id,
        title: answers2.title,
        person_id: answers2.person_id,
        documents_screeners_id: answers2.documents_screeners_id,
        document_status: answers2.document_status,
        screener_questions_id: answers2.screeners_questions_id,
        question_responses: answers2.question_responses,
        created_at: answers2.created_at
      }
    end

    context "when person id is nil" do
      let(:person_id) { nil }

      it "returns the answers" do
        expect(subject).to contain_exactly(serialized_answers1, serialized_answers2)
      end
    end

    context "when person id not nil" do
      let(:person_id) { id }

      it "returns the answers" do
        expect(subject).to contain_exactly(serialized_answers1)
      end
    end
  end

  describe ".find_questions" do
    subject { described_class.find_questions(questions.id) }

    let(:questions) { create(:screeners__questions) }

    it "returns the questions" do
      expect(subject).to eq({
                              id: questions.id,
                              title: questions.title,
                              questions: questions.questions,
                              created_at: questions.created_at
                            })
    end
  end

  describe ".find_answers" do
    subject { described_class.find_answers(answers.id) }

    let(:answers) { create(:screeners__answers) }

    it "returns the answers" do
      expect(subject).to eq({
                              id: answers.id,
                              title: answers.title,
                              person_id: answers.person_id,
                              documents_screeners_id: answers.documents_screeners_id,
                              document_status: answers.document_status,
                              screener_questions_id: answers.screeners_questions_id,
                              question_responses: answers.question_responses,
                              created_at: answers.created_at
                            })
    end
  end
end
