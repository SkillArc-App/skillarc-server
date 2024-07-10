module TrainingProviders
  class TrainingProviderReactor < MessageReactor
    def can_replay?
      true
    end

    on_message Commands::CreateTrainingProvider::V1 do |message|
      message_service.create_once_for_aggregate!(
        trace_id: message.trace_id,
        aggregate: message.aggregate,
        schema: Events::TrainingProviderCreated::V1,
        data: {
          name: message.data.name,
          description: message.data.description
        }
      )
    end

    on_message Commands::CreateTrainingProviderProgram::V1 do |message|
      messages = MessageService.aggregate_events(message.aggregate).select { |m| m.occurred_at <= message.occurred_at }
      return unless Projectors::Streams::HasOccurred.new(schema: Events::TrainingProviderCreated::V1).project(messages)

      message_service.create_once_for_trace!(
        trace_id: message.trace_id,
        aggregate: message.aggregate,
        schema: Events::TrainingProviderProgramCreated::V1,
        data: {
          program_id: message.data.program_id,
          name: message.data.name,
          description: message.data.description
        }
      )
    end

    on_message Commands::UpdateTrainingProviderProgram::V1 do |message|
      return unless MessageService.aggregate_events(message.aggregate)
                                  .select { |m| m.occurred_at <= message.occurred_at }
                                  .select { |m| m.schema == Events::TrainingProviderProgramCreated::V1 }
                                  .detect { |m| m.data.program_id == message.data.program_id }

      message_service.create_once_for_trace!(
        trace_id: message.trace_id,
        aggregate: message.aggregate,
        schema: Events::TrainingProviderProgramUpdated::V1,
        data: {
          program_id: message.data.program_id,
          name: message.data.name,
          description: message.data.description
        }
      )
    end
  end
end
