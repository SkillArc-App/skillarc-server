module JobOrders
  class JobOrdersReactor < MessageConsumer
    def reset_for_replay
      # Stuff
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

    on_message Events::JobOrderAdded::V1 do |message|
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
      when *JobOrders::OpenStatus::ALL
        message_service.create_once_for_trace!(
          trace_id: message.trace_id,
          aggregate: message.aggregate,
          schema: Events::JobOrderActivated::V1,
          data: Messages::Nothing
        )
      when *JobOrders::IdleStatus::ALL
        message_service.create_once_for_trace!(
          trace_id: message.trace_id,
          aggregate: message.aggregate,
          schema: Events::JobOrderStalled::V1,
          data: {
            status: current_status
          }
        )
      when *JobOrders::CloseStatus::ALL
        message_service.create_once_for_trace!(
          trace_id: message.trace_id,
          aggregate: message.aggregate,
          schema: Events::JobOrderClosed::V1,
          data: {
            status: current_status
          }
        )
      end
    end
  end
end
