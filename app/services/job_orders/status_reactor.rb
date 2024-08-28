module JobOrders
  class StatusReactor < MessageReactor
    def can_replay?
      true
    end

    on_message Events::OrderCountAdded::V1, :sync do |message|
      emit_new_status_if_necessary(message)
    end

    on_message Events::ScreenerQuestionsAdded::V1, :sync do |message|
      emit_new_status_if_necessary(message)
    end

    on_message Events::ScreenerQuestionsBypassed::V1, :sync do |message|
      emit_new_status_if_necessary(message)
    end

    on_message Events::Reactivated::V1, :sync do |message|
      emit_new_status_if_necessary(message)
    end

    on_message Events::ClosedNotFilled::V1, :sync do |message|
      emit_new_status_if_necessary(message)
    end

    on_message Events::CriteriaAdded::V1 do |message|
      emit_new_status_if_necessary(message)
    end

    on_message Events::CandidateAdded::V3, :sync do |message|
      emit_new_status_if_necessary(message)
    end

    on_message Events::CandidateRecommended::V2, :sync do |message|
      emit_new_status_if_necessary(message)
    end

    on_message Events::CandidateScreened::V1, :sync do |message|
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
      messages = MessageService.stream_events(message.stream).select { |m| m.occurred_at <= message.occurred_at }
      existing_status = Projectors::JobOrderExistingStatus.new.project(messages).status
      current_status = JobOrders::Projectors::JobOrderStatus.new.project(messages).status
      return if current_status == existing_status

      message_service.create_once_for_trace!(
        trace_id: message.trace_id,
        stream: message.stream,
        schema: Events::StatusUpdated::V1,
        data: {
          status: current_status
        }
      )
    end
  end
end
