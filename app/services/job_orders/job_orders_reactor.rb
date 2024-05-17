module JobOrders
  class JobOrdersReactor < MessageReactor # rubocop:disable Metrics/ClassLength
    def can_replay?
      true
    end

    def add_job_order(job_order_id:, job_id:, trace_id:)
      message_service.create!(
        schema: Commands::AddJobOrder::V1,
        job_order_id:,
        trace_id:,
        data: {
          job_id:
        }
      )
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
        schema: Commands::ActivateJobOrder::V1,
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

    def add_note(job_order_id:, originator:, note:, note_id:, trace_id:)
      message_service.create!(
        schema: Events::JobOrderNoteAdded::V1,
        job_order_id:,
        trace_id:,
        data: {
          originator:,
          note:,
          note_id:
        }
      )
    end

    def modify_note(job_order_id:, originator:, note_id:, note:, trace_id:)
      message_service.create!(
        schema: Events::JobOrderNoteModified::V1,
        job_order_id:,
        trace_id:,
        data: {
          originator:,
          note:,
          note_id:
        }
      )
    end

    def remove_note(job_order_id:, originator:, note_id:, trace_id:)
      message_service.create!(
        schema: Events::JobOrderNoteRemoved::V1,
        job_order_id:,
        trace_id:,
        data: {
          originator:,
          note_id:
        }
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

    def update_status(job_order_id:, seeker_id:, status:, trace_id:)
      case status
      when CandidateStatus::ADDED
        message_service.create!(
          schema: Events::JobOrderCandidateAdded::V1,
          job_order_id:,
          trace_id:,
          data: {
            seeker_id:
          }
        )
      when CandidateStatus::RECOMMENDED
        message_service.create!(
          schema: Events::JobOrderCandidateRecommended::V1,
          job_order_id:,
          trace_id:,
          data: {
            seeker_id:
          }
        )
      when CandidateStatus::HIRED
        message_service.create!(
          schema: Events::JobOrderCandidateHired::V1,
          job_order_id:,
          trace_id:,
          data: {
            seeker_id:
          }
        )
      when CandidateStatus::RESCINDED
        message_service.create!(
          schema: Events::JobOrderCandidateRescinded::V1,
          job_order_id:,
          trace_id:,
          data: {
            seeker_id:
          }
        )
      end
    end

    on_message Events::ApplicantStatusUpdated::V6 do |message|
      return if message.data.status != ApplicantStatus::StatusTypes::NEW

      # Grab any active job orders
      active_job_order = active_job_order(message.occurred_at, message.data.job_id)

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

    on_message Commands::ActivateJobOrder::V1, :sync do |message|
      job_order_added = ::Projectors::Aggregates::GetFirst.project(
        schema: Events::JobOrderAdded::V1,
        aggregate: message.aggregate
      )

      if job_order_added.blank?
        Sentry.capture_exception(MessageConsumer::FailedToHandleMessage.new("Job Order not found", message))
      elsif active_job_order(message.occurred_at, job_order_added.data.job_id).present?
        message_service.create_once_for_trace!(
          schema: Events::JobOrderActivationFailed::V1,
          trace_id: message.trace_id,
          aggregate: message.aggregate,
          data: {
            reason: "There is an existing active job order present"
          }
        )
      else
        message_service.create_once_for_trace!(
          schema: Events::JobOrderActivated::V1,
          trace_id: message.trace_id,
          aggregate: message.aggregate,
          data: Messages::Nothing
        )
      end
    end

    on_message Commands::AddJobOrder::V1, :sync do |message|
      if active_job_order(message.occurred_at, message.data.job_id).present?
        message_service.create_once_for_trace!(
          schema: Events::JobOrderCreationFailed::V1,
          trace_id: message.trace_id,
          aggregate: message.aggregate,
          data: {
            job_id: message.data.job_id,
            reason: "There is an existing active job order present"
          }
        )
      else
        message_service.create_once_for_trace!(
          schema: Events::JobOrderAdded::V1,
          trace_id: message.trace_id,
          aggregate: message.aggregate,
          data: {
            job_id: message.data.job_id
          }
        )
      end
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
      messages = MessageService.aggregate_events(message.aggregate).select { |m| m.occurred_at <= message.occurred_at }
      existing_status = Projectors::JobOrderExistingStatus.new.project(messages).status
      current_status = JobOrders::Projectors::JobOrderStatus.new.project(messages).status
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

    def job_order_added_events(job_id)
      # Get all job order for this job
      Events::JobOrderAdded::V1
        .all_messages
        .select { |job_order| job_order.data.job_id == job_id }
    end

    def active_job_order(occurred_at, job_id)
      # Get all job order for this job
      job_orders = job_order_added_events(job_id)

      # Grab the job order that is active
      job_orders.detect do |job_order|
        messages = MessageService.aggregate_events(job_order.aggregate).select { |m| m.occurred_at <= occurred_at }

        status = Projectors::JobOrderExistingStatus.new.project(messages).status
        JobOrders::ClosedStatus::ALL.exclude?(status)
      end
    end
  end
end
