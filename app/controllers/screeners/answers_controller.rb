module Screeners
  class AnswersController < ScreenerController
    include MessageEmitter

    def index
      render json: Screeners::ScreenerQuery.all_answers(params[:person_id])
    end

    def show
      render json: Screeners::ScreenerQuery.find_answers(params[:id])
    end

    def create
      with_message_service do
        message_service.create!(
          trace_id: request.request_id,
          screener_answers_id: SecureRandom.uuid,
          schema: Commands::CreateAnswers::V2,
          data: {
            title: params[:title],
            screener_questions_id: params[:screener_questions_id],
            person_id: params[:person_id],
            question_responses: params[:question_responses].map do |qr|
              QuestionResponse.new(
                question: qr[:question],
                response: qr[:response]
              )
            end
          },
          metadata: requestor_metadata
        )
      end

      head :created
    end

    def generate_file
      with_message_service do
        message_service.create!(
          trace_id: request.request_id,
          screener_document_id: SecureRandom.uuid,
          schema: Documents::Commands::GenerateScreenerForAnswers::V1,
          data: {
            screener_answers_id: params[:answer_id],
            document_kind: params[:document_kind] || Documents::DocumentKind::PDF
          },
          metadata: {
            requestor_type: Requestor::Kinds::USER,
            requestor_id: current_user.id,
            requestor_email: current_user.email
          }
        )
      end

      head :created
    end

    def update
      with_message_service do
        message_service.create!(
          trace_id: request.request_id,
          screener_answers_id: params[:id],
          schema: Commands::UpdateAnswers::V1,
          data: {
            title: params[:title],
            question_responses: params[:question_responses].map do |qr|
              QuestionResponse.new(
                question: qr[:question],
                response: qr[:response]
              )
            end
          },
          metadata: requestor_metadata
        )
      end

      head :accepted
    end
  end
end
