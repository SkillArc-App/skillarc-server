module Infrastructure
  class InfrastructureReactor < MessageConsumer
    def reset_for_replay; end

    on_message Commands::ScheduleCommand::V1, :sync do |message|
      schedule_command = Infrastructure::ScheduledCommand.find_by(task_id: message.aggregate.task_id)
      return if schedule_command.present?

      message_service.create!(
        schema: Events::CommandScheduled::V1,
        trace_id: message.trace_id,
        task_id: message.aggregate.task_id,
        data: {
          execute_at: message.data.execute_at,
          message: message.data.message
        },
        metadata: {
          requestor_type: message.metadata.requestor_type,
          requestor_id: message.metadata.requestor_id
        }
      )
    end
  end
end
