module JobOrders
  class JobOrdersReactor < MessageReactor
    def can_replay?
      true
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
          schema: Events::CandidateAdded::V3,
          job_order_id:,
          trace_id:,
          data: {
            person_id:
          },
          metadata: {
            requestor_type: nil,
            requestor_id: nil,
            requestor_email: nil
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
      when CandidateStatus::SCREENED
        message_service.create!(
          schema: Events::CandidateScreened::V1,
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
          job_id: message.stream.id
        }
      )
    end

    on_message ::Events::ApplicantStatusUpdated::V6 do |message|
      return if message.data.status != ApplicantStatus::StatusTypes::NEW

      # Grab any active job orders
      active_job_order = active_job_order(message.occurred_at, message.data.job_id)

      return if active_job_order.nil?

      message_service.create_once_for_trace!(
        schema: JobOrders::Events::CandidateAdded::V3,
        trace_id: message.trace_id,
        stream: active_job_order.stream,
        data: {
          person_id: message.data.seeker_id
        },
        metadata: {
          requestor_type: nil,
          requestor_id: nil,
          requestor_email: nil
        }
      )

      message_service.create_once_for_trace!(
        schema: JobOrders::Events::CandidateApplied::V2,
        trace_id: message.trace_id,
        stream: active_job_order.stream,
        data: {
          person_id: message.data.seeker_id,
          applied_at: message.occurred_at
        }
      )
    end

    on_message Commands::AddCandidate::V2, :sync do |message|
      messages = MessageService.stream_events(message.stream)

      unless messages.any? { |m| m.schema == Events::CandidateAdded::V3 && m.data.person_id == message.data.person_id }
        message_service.create_once_for_trace!(
          schema: Events::CandidateAdded::V3,
          stream: message.stream,
          trace_id: message.trace_id,
          data: {
            person_id: message.data.person_id
          },
          metadata: {
            requestor_type: message.metadata[:requestor_type],
            requestor_id: message.metadata[:requestor_id],
            requestor_email: message.metadata[:requestor_email]
          }
        )
      end
    end

    on_message Commands::Activate::V1, :sync do |message|
      job_order_added = ::Projectors::Streams::GetFirst.project(
        schema: Events::Added::V1,
        stream: message.stream
      )

      if job_order_added.blank?
        Sentry.capture_exception(MessageConsumer::FailedToHandleMessage.new("Job Order not found", message))
      elsif active_job_order(message.occurred_at, job_order_added.data.job_id).present?
        message_service.create_once_for_trace!(
          schema: Events::ActivationFailed::V1,
          trace_id: message.trace_id,
          stream: message.stream,
          data: {
            reason: "There is an existing active job order present"
          }
        )
      else
        message_service.create_once_for_trace!(
          schema: Events::Reactivated::V1,
          trace_id: message.trace_id,
          stream: message.stream,
          data: Core::Nothing
        )
      end
    end

    on_message Commands::Add::V1, :sync do |message|
      if active_job_order(message.occurred_at, message.data.job_id).present?
        message_service.create_once_for_trace!(
          schema: JobOrders::Events::CreationFailed::V1,
          trace_id: message.trace_id,
          stream: message.stream,
          data: {
            job_id: message.data.job_id,
            reason: "There is an existing active job order present"
          }
        )
      else
        message_service.create_once_for_trace!(
          schema: JobOrders::Events::Added::V1,
          trace_id: message.trace_id,
          stream: message.stream,
          data: {
            job_id: message.data.job_id
          }
        )
      end
    end

    on_message Commands::CloseAsNotFilled::V1, :sync do |message|
      message_service.create_once_for_trace!(
        schema: Events::ClosedNotFilled::V1,
        stream: message.stream,
        trace_id: message.trace_id,
        data: Core::Nothing
      )
    end

    on_message Commands::AddOrderCount::V1, :sync do |message|
      message_service.create_once_for_trace!(
        schema: Events::OrderCountAdded::V1,
        stream: message.stream,
        trace_id: message.trace_id,
        data: {
          order_count: message.data.order_count
        }
      )
    end

    on_message Commands::AddScreenerQuestions::V1, :sync do |message|
      return unless message_service.query
                                   .by_stream(Screeners::Streams::Questions.new(screener_questions_id: message.data.screener_questions_id))
                                   .by_schema(Screeners::Events::QuestionsCreated::V1)
                                   .exists?

      message_service.create_once_for_trace!(
        schema: Events::ScreenerQuestionsAdded::V1,
        stream: message.stream,
        trace_id: message.trace_id,
        data: {
          screener_questions_id: message.data.screener_questions_id
        }
      )
    end

    on_message Commands::BypassScreenerQuestions::V1, :sync do |message|
      message_service.create_once_for_stream!(
        schema: Events::ScreenerQuestionsBypassed::V1,
        stream: message.stream,
        trace_id: message.trace_id,
        data: Core::Nothing
      )
    end

    private

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
        messages = MessageService.stream_events(job_order.stream).select { |m| m.occurred_at <= occurred_at }

        status = Projectors::JobOrderExistingStatus.new.project(messages).status
        JobOrders::ClosedStatus::ALL.exclude?(status)
      end
    end
  end
end
