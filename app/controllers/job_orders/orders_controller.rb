module JobOrders
  class OrdersController < DashboardController
    include MessageEmitter

    def index
      render json: JobOrdersQuery.all_orders
    end

    def show
      render json: JobOrdersQuery.find_order(params[:id])
    end

    def create
      with_message_service do
        JobOrders::JobOrdersReactor.new(message_service:).add_job_order(
          job_order_id: SecureRandom.uuid,
          job_id: params[:job_id],
          trace_id: request.request_id
        )
      end

      head :created
    end

    def update
      with_message_service do
        JobOrders::JobOrdersReactor.new(message_service:).add_order_count(
          job_order_id: params[:id],
          order_count: params[:order_count],
          trace_id: request.request_id
        )
      end

      head :accepted
    end

    def activate
      with_message_service do
        JobOrders::JobOrdersReactor.new(message_service:).activate_job_order(
          job_order_id: params[:order_id],
          trace_id: request.request_id
        )
      end

      head :accepted
    end

    def close_not_filled
      with_message_service do
        JobOrders::JobOrdersReactor.new(message_service:).close_job_order_not_filled(
          job_order_id: params[:order_id],
          trace_id: request.request_id
        )
      end

      head :accepted
    end
  end
end
