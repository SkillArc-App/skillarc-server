module JobOrders
  class JobOrdersReactor < MessageReactor
    def can_replay?
      true
    end

    on_message Events::JobCreated::V3 do |message|
      message_service.create_once_for_trace!(
        schema: Events::JobOrderAdded::V1,
        job_order_id: SecureRandom.uuid,
        trace_id: message.trace_id,
        data: {
          job_id: message.aggregate.id
        }
      )
    end

    on_message Events::JobOrderOrderCountAdded::V1 do |message|
      emit_new_status_if_necessary(message)
    end

    on_message Events::JobOrderCandidateAdded::V1 do |message|
      emit_new_status_if_necessary(message)
    end

    on_message Events::JobOrderCandidateRecommended::V1 do |message|
      emit_new_status_if_necessary(message)
    end

    on_message Events::JobOrderCandidateHired::V1 do |message|
      emit_new_status_if_necessary(message)
    end

    on_message Events::JobOrderCandidateRescinded::V1 do |message|
      emit_new_status_if_necessary(message)
    end

    private

    def emit_new_status_if_necessary(message)
      existing_status = Projectors::JobOrderExistingStatus.project(aggregate: message.aggregate).status
      current_status = JobOrders::Projectors::JobOrderStatus.project(aggregate: message.aggregate).status
      return if current_status == existing_status

      case current_status
      when *JobOrders::ActivatedStatus::ALL
        message_service.create_once_for_trace!(
          trace_id: message.trace_id,
          aggregate: message.aggregate,
          schema: Events::JobOrderActivated::V1,
          data: Messages::Nothing
        )
      when *JobOrders::StalledStatus::ALL
        message_service.create_once_for_trace!(
          trace_id: message.trace_id,
          aggregate: message.aggregate,
          schema: Events::JobOrderStalled::V1,
          data: {
            status: current_status
          }
        )
      when JobOrders::ClosedStatus::FILLED
        message_service.create_once_for_trace!(
          trace_id: message.trace_id,
          aggregate: message.aggregate,
          schema: Events::JobOrderFilled::V1,
          data: Messages::Nothing
        )
      when JobOrders::ClosedStatus::NOT_FILLED
        message_service.create_once_for_trace!(
          trace_id: message.trace_id,
          aggregate: message.aggregate,
          schema: Events::JobOrderNotFilled::V1,
          data: Messages::Nothing
        )
      end
    end
  end
end
