module Coaches
  class JobOrdersController < ApplicationController
    include Secured
    include CoachAuth
    include MessageEmitter

    before_action :authorize
    before_action :coach_authorize

    def index
      render json: JobOrders::JobOrdersQuery.all_orders
    end

    def recommend
      job_order_id = params[:job_order_id]
      person_id = params[:seeker_id]

      with_message_service do
        message_service.create!(
          trace_id: request.request_id,
          job_order_id:,
          schema: JobOrders::Commands::AddCandidate::V1,
          data: {
            person_id:
          }
        )
      end

      head :accepted
    end
  end
end
