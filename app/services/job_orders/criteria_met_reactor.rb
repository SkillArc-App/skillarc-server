module JobOrders
  class CriteriaMetReactor < MessageReactor
    def can_replay?
      true
    end

    on_message Events::Added::V1 do |message|
      emit_criteria_met_if_necessary(::Jobs::Streams::Job.new(job_id: message.data.job_id), message.trace_id)
    end

    on_message Jobs::Events::JobCreated::V3 do |message|
      emit_criteria_met_if_necessary(message.stream, message.trace_id)
    end

    on_message Jobs::Events::JobAttributeCreated::V2 do |message|
      emit_criteria_met_if_necessary(message.stream, message.trace_id)
    end

    on_message Jobs::Events::JobAttributeUpdated::V2 do |message|
      emit_criteria_met_if_necessary(message.stream, message.trace_id)
    end

    on_message Jobs::Events::JobAttributeDestroyed::V2 do |message|
      emit_criteria_met_if_necessary(message.stream, message.trace_id)
    end

    private

    def emit_criteria_met_if_necessary(job_stream, trace_id)
      messages = MessageService.stream_events(job_stream)
      return unless Projectors::JobOrderCriteriaMet.new.project(messages)

      # Overall this is going to be pretty inefficient
      # Lots of queries. What I think might be the solution
      # Would be to emit an event on the job stream which
      # Links all of the associated job orders.
      # Also the create once for stream is also going to query
      # The events table for each job order.
      JobOrders::Events::Added::V1.all_messages.each do |m|
        next unless m.data.job_id == job_stream.id

        message_service.create_once_for_stream!(
          schema: JobOrders::Events::CriteriaAdded::V1,
          trace_id:,
          stream: m.stream,
          data: Core::Nothing
        )
      end
    end
  end
end
