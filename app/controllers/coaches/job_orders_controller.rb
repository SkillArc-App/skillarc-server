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
        CoachesEventEmitter.new(message_service:).recommend_for_job_order(
          job_order_id:,
          person_id:,
          trace_id: request.request_id
        )
      end

      head :accepted
    end
  end
end
