module JobOrders
  class OrdersController < DashboardController
    include MessageEmitter

    def index
      render json: JobOrdersQuery.all_orders
    end

    def show
      render json: JobOrdersQuery.find_order(params[:id])
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
  end
end
