module JobOrders
  class JobOrdersReactor < MessageReactor # rubocop:disable Metrics/ClassLength
    def can_replay?
      true
    end

    def add_order_count(job_order_id:, order_count:, trace_id:)
      message_service.create!(
        schema: JobOrders::Events::OrderCountAdded::V1,
        job_order_id:,
        trace_id:,
        data: {
          order_count:
        }
      )
    end

    def close_job_order_not_filled(job_order_id:, trace_id:)
      message_service.create!(
        schema: Events::NotFilled::V1,
        job_order_id:,
        trace_id:,
        data: Core::Nothing
      )
    end

    def add_note(job_order_id:, originator:, note:, note_id:, trace_id:)
      message_service.create!(
        schema: Events::NoteAdded::V1,
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
        schema: Events::NoteModified::V1,
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
        schema: Events::NoteRemoved::V1,
        job_order_id:,
        trace_id:,
        data: {
          originator:,
          note_id:
        }
      )
    end

    def update_status(job_order_id:, person_id:, status:, trace_id:)
      case status
      when CandidateStatus::ADDED
        message_service.create!(
          schema: Events::CandidateAdded::V2,
          job_order_id:,
          trace_id:,
          data: {
            person_id:
          }
        )
      when CandidateStatus::RECOMMENDED
        message_service.create!(
          schema: Events::CandidateRecommended::V2,
          job_order_id:,
          trace_id:,
          data: {
            person_id:
          }
        )
      when CandidateStatus::HIRED
        message_service.create!(
          schema: Events::CandidateHired::V2,
          job_order_id:,
          trace_id:,
          data: {
            person_id:
          }
        )
      when CandidateStatus::RESCINDED
        message_service.create!(
          schema: Events::CandidateRescinded::V2,
          job_order_id:,
          trace_id:,
          data: {
            person_id:
          }
        )
      end
    end

    on_message ::Events::JobCreated::V3 do |message|
      message_service.create_once_for_trace!(
        schema: Events::Added::V1,
        job_order_id: SecureRandom.uuid,
        trace_id: message.trace_id,
        data: {
          job_id: message.aggregate.id
        }
      )
    end

    on_message ::Events::ApplicantStatusUpdated::V6 do |message|
      return if message.data.status != ApplicantStatus::StatusTypes::NEW

      # Grab any active job orders
      active_job_order = active_job_order(message.occurred_at, message.data.job_id)

      return if active_job_order.nil?

      message_service.create_once_for_trace!(
        schema: JobOrders::Events::CandidateAdded::V2,
        trace_id: message.trace_id,
        aggregate: active_job_order.aggregate,
        data: {
          person_id: message.data.seeker_id
        }
      )

      message_service.create_once_for_trace!(
        schema: JobOrders::Events::CandidateApplied::V2,
        trace_id: message.trace_id,
        aggregate: active_job_order.aggregate,
        data: {
          person_id: message.data.seeker_id,
          applied_at: message.occurred_at
        }
      )
    end

    on_message Commands::Activate::V1, :sync do |message|
      job_order_added = ::Projectors::Aggregates::GetFirst.project(
        schema: JobOrders::Events::Added::V1,
        aggregate: message.aggregate
      )

      if job_order_added.blank?
        Sentry.capture_exception(MessageConsumer::FailedToHandleMessage.new("Job Order not found", message))
      elsif active_job_order(message.occurred_at, job_order_added.data.job_id).present?
        message_service.create_once_for_trace!(
          schema: JobOrders::Events::ActivationFailed::V1,
          trace_id: message.trace_id,
          aggregate: message.aggregate,
          data: {
            reason: "There is an existing active job order present"
          }
        )
      else
        message_service.create_once_for_trace!(
          schema: JobOrders::Events::Activated::V1,
          trace_id: message.trace_id,
          aggregate: message.aggregate,
          data: Core::Nothing
        )
      end
    end

    on_message Commands::Add::V1, :sync do |message|
      if active_job_order(message.occurred_at, message.data.job_id).present?
        message_service.create_once_for_trace!(
          schema: JobOrders::Events::CreationFailed::V1,
          trace_id: message.trace_id,
          aggregate: message.aggregate,
          data: {
            job_id: message.data.job_id,
            reason: "There is an existing active job order present"
          }
        )
      else
        message_service.create_once_for_trace!(
          schema: JobOrders::Events::Added::V1,
          trace_id: message.trace_id,
          aggregate: message.aggregate,
          data: {
            job_id: message.data.job_id
          }
        )
      end
    end

    on_message Events::OrderCountAdded::V1, :sync do |message|
      emit_new_status_if_necessary(message)
    end

    on_message Events::CandidateAdded::V2, :sync do |message|
      emit_new_status_if_necessary(message)
    end

    on_message Events::CandidateRecommended::V2, :sync do |message|
      emit_new_status_if_necessary(message)
    end

    on_message Events::CandidateHired::V2, :sync do |message|
      emit_new_status_if_necessary(message)
    end

    on_message Events::CandidateRescinded::V2, :sync do |message|
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
          schema: JobOrders::Events::Activated::V1,
          data: Core::Nothing
        )
      when *JobOrders::StalledStatus::ALL
        message_service.create_once_for_trace!(
          trace_id: message.trace_id,
          aggregate: message.aggregate,
          schema: JobOrders::Events::Stalled::V1,
          data: {
            status: current_status
          }
        )
      when JobOrders::ClosedStatus::FILLED
        message_service.create_once_for_trace!(
          trace_id: message.trace_id,
          aggregate: message.aggregate,
          schema: JobOrders::Events::Filled::V1,
          data: Core::Nothing
        )
      when JobOrders::ClosedStatus::NOT_FILLED
        message_service.create_once_for_trace!(
          trace_id: message.trace_id,
          aggregate: message.aggregate,
          schema: JobOrders::Events::NotFilled::V1,
          data: Core::Nothing
        )
      end
    end

    def job_order_added_events(job_id)
      # Get all job order for this job
      JobOrders::Events::Added::V1
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
