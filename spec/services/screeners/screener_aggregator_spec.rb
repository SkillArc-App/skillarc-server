require 'rails_helper'

RSpec.describe Screeners::ScreenerAggregator do
  it_behaves_like "a replayable message consumer"

  let(:consumer) { described_class.new }

  describe "#handle_message" do
    subject { consumer.handle_message(message) }

    context "when the message is questions created" do
      let(:message) do
        build(
          :message,
          schema: Screeners::Events::QuestionsCreated::V1
        )
      end

      it "creates questions" do
        expect { subject }.to change(Screeners::Questions, :count).from(0).to(1)

        questions = Screeners::Questions.first
        expect(questions.id).to eq(message.stream.id)
        expect(questions.created_at).to eq(message.occurred_at)
        expect(questions.title).to eq(message.data.title)
        expect(questions.questions).to eq(message.data.questions)
      end
    end

    context "when the message is answers created" do
      let(:message) do
        build(
          :message,
          schema: Screeners::Events::AnswersCreated::V2,
          data: {
            screener_questions_id: questions.id
          }
        )
      end

      let(:questions) { create(:screeners__questions) }

      it "creates answers" do
        expect { subject }.to change(Screeners::Answers, :count).from(0).to(1)

        answers = Screeners::Answers.first
        expect(answers.id).to eq(message.stream.id)
        expect(answers.created_at).to eq(message.occurred_at)
        expect(answers.questions).to eq(questions)
        expect(answers.title).to eq(message.data.title)
        expect(answers.question_responses).to eq(message.data.question_responses)
      end
    end

    context "when the message is questions updated" do
      let(:message) do
        build(
          :message,
          stream_id: questions.id,
          schema: Screeners::Events::QuestionsUpdated::V1,
          data: {
            title: "New",
            questions: ["Data?"]
          }
        )
      end

      let(:questions) { create(:screeners__questions) }

      it "updates questions" do
        expect { subject }.to change(Screeners::Questions, :count).from(0).to(1)

        questions.reload
        expect(questions.title).to eq(message.data.title)
        expect(questions.questions).to eq(message.data.questions)
      end
    end

    context "when the message is answers created" do
      let(:message) do
        build(
          :message,
          schema: Screeners::Events::AnswersUpdated::V1,
          stream_id: answers.id,
          data: {
            title: "New",
            question_responses: [Screeners::QuestionResponse.new(question: "New?", response: "data")]
          }
        )
      end

      let(:answers) { create(:screeners__answers) }

      it "update answers" do
        subject

        answers.reload
        expect(answers.title).to eq(message.data.title)
        expect(answers.question_responses).to eq(message.data.question_responses)
      end
    end

    context "when the message is screener generation requested" do
      let(:message) do
        build(
          :message,
          schema: Documents::Events::ScreenerGenerationRequested::V1,
          data: {
            screener_answers_id: answers.id
          }
        )
      end

      let(:answers) { create(:screeners__answers) }

      it "update answers" do
        subject

        answers.reload
        expect(answers.documents_screeners_id).to eq(message.stream.id)
        expect(answers.document_status).to eq(Documents::DocumentStatus::PROCESSING)
      end
    end

    context "when the message is screener generation failed" do
      let(:message) do
        build(
          :message,
          schema: Documents::Events::ScreenerGenerationFailed::V1,
          stream_id:
        )
      end

      context "when there is an answer that points to this screener" do
        let(:stream_id) { answers.documents_screeners_id }
        let(:answers) { create(:screeners__answers, documents_screeners_id: SecureRandom.uuid) }

        it "update answers" do
          subject

          answers.reload
          expect(answers.document_status).to eq(Documents::DocumentStatus::FAILED)
        end
      end

      context "when there is not an answer that points to this screener" do
        let(:stream_id) { SecureRandom.uuid }

        it "does nothing" do
          subject
        end
      end
    end

    context "when the message is screener generated" do
      let(:message) do
        build(
          :message,
          schema: Documents::Events::ScreenerGenerated::V1,
          stream_id:
        )
      end

      context "when there is an answer that points to this screener" do
        let(:stream_id) { answers.documents_screeners_id }
        let(:answers) { create(:screeners__answers, documents_screeners_id: SecureRandom.uuid) }

        it "update answers" do
          subject

          answers.reload
          expect(answers.document_status).to eq(Documents::DocumentStatus::SUCCEEDED)
        end
      end

      context "when there is not an answer that points to this screener" do
        let(:stream_id) { SecureRandom.uuid }

        it "does nothing" do
          subject
        end
      end
    end
  end
end
