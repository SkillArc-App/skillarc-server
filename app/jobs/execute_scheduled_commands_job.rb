class ExecuteScheduledCommandsJob < ApplicationJob
  queue_as :default

  include MessageEmitter

  def perform
    with_message_service do
      Infastructure::ScheduledCommand.ready_to_execute.each do |scheduled_command|
        command = scheduled_command.message
        schema = command.schema

        message_service.create!(
          **{
            schema:,
            data: command.data,
            trace_id: command.trace_id,
            id: command.id,
            metadata: command.metadata,
            schema.aggregate.id => command.aggregate.id
          }
        )

        message_service.create!(
          schema: Events::ScheduledCommandsExecuted::V1,
          data: Messages::Nothing,
          trace_id: command.trace_id,
          task_id: scheduled_command.task_id
        )
      end
    end
  end
end
