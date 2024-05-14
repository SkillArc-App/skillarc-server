module JobOrders
  class JobOrdersReactor < MessageReactor
    def can_replay?
      true
    end

    def add_order_count(job_order_id:, order_count:, trace_id:)
      message_service.create!(
        schema: Events::JobOrderOrderCountAdded::V1,
        job_order_id:,
        trace_id:,
        data: {
          order_count:
        }
      )
    end

    def activate_job_order(job_order_id:, trace_id:)
      message_service.create!(
        schema: Events::JobOrderActivated::V1,
        job_order_id:,
        trace_id:,
        data: Messages::Nothing
      )
    end

    def close_job_order_not_filled(job_order_id:, trace_id:)
      message_service.create!(
        schema: Events::JobOrderNotFilled::V1,
        job_order_id:,
        trace_id:,
        data: Messages::Nothing
      )
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

    on_message Events::ApplicantStatusUpdated::V6 do |message|
      return if message.data.status != ApplicantStatus::StatusTypes::NEW

      # Get all job order for this job
      job_orders = Events::JobOrderAdded::V1
                   .all_messages
                   .select { |job_order| job_order.data.job_id == message.data.job_id }

      # Grab the job order that is active
      active_job_order = job_orders.detect do |job_order|
        status = Projectors::JobOrderExistingStatus.project(aggregate: job_order.aggregate).status
        JobOrders::ClosedStatus::ALL.exclude?(status)
      end

      return if active_job_order.nil?

      message_service.create_once_for_trace!(
        schema: Events::JobOrderCandidateAdded::V1,
        trace_id: message.trace_id,
        aggregate: active_job_order.aggregate,
        data: {
          seeker_id: message.data.seeker_id
        }
      )

      message_service.create_once_for_trace!(
        schema: Events::JobOrderCandidateApplied::V1,
        trace_id: message.trace_id,
        aggregate: active_job_order.aggregate,
        data: {
          seeker_id: message.data.seeker_id,
          applied_at: message.occurred_at
        }
      )
    end

    on_message Events::JobOrderOrderCountAdded::V1, :sync do |message|
      emit_new_status_if_necessary(message)
    end

    on_message Events::JobOrderCandidateAdded::V1, :sync do |message|
      emit_new_status_if_necessary(message)
    end

    on_message Events::JobOrderCandidateRecommended::V1, :sync do |message|
      emit_new_status_if_necessary(message)
    end

    on_message Events::JobOrderCandidateHired::V1, :sync do |message|
      emit_new_status_if_necessary(message)
    end

    on_message Events::JobOrderCandidateRescinded::V1, :sync do |message|
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

    def canidate_added?(aggregate, seeker_id)
      MessageService.aggregate_events(aggregate).any? do |m|
        m.schema == Events::JobOrderCandidateAdded::V1 && m.data.seeker_id == seeker_id
      end
    end
  end
end
