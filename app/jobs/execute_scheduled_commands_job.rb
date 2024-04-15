class ExecuteScheduledCommandsJob < ApplicationJob
  queue_as :default

  include MessageEmitter

  def perform
    with_message_service do
      Infastructure::ScheduledCommand.ready_to_execute.each do |scheduled_command|
        scheduled_command.execute!(message_service)
      end
    end
  end
end
