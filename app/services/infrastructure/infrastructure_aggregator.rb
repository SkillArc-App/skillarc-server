module Infrastructure
  class InfrastructureAggregator < MessageConsumer
    def reset_for_replay
      ScheduledCommand.delete_all
    end

    on_message Events::CommandScheduled::V1, :sync do |message|
      Infrastructure::ScheduledCommand.create!(
        execute_at: message.data.execute_at,
        task_id: message.aggregate.task_id,
        message: message.data.message,
        state: Infrastructure::ScheduledCommand::State::ENQUEUED
      )
    end

    on_message Events::ScheduledCommandExecuted::V1, :sync do |message|
      schedule_command = Infrastructure::ScheduledCommand.find_by!(task_id: message.aggregate.task_id)
      schedule_command.execute!
    end
  end
end
