module JobOrders
  class CandidatesController < DashboardController
    include MessageEmitter

    def update
      job_order_id = params[:order_id]
      status = params[:status]

      # TODO: We have a cleanup task to come up with a better way to handle this. Not sure if we always want to pass
      # the seeker_id, but it's what the events expect right now.
      seeker_id = params[:id]

      with_message_service do
        JobOrders::JobOrdersReactor.new(message_service:).update_status(
          job_order_id:,
          seeker_id:,
          status:,
          trace_id: request.request_id
        )
      end
    end
  end
end
