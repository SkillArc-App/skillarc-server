module JobOrders
  class OrdersController < DashboardController
    def index
      render json: JobOrdersQuery.all_orders
    end

    def show
      render json: JobOrdersQuery.find_order(params[:id])
    end
  end
end
