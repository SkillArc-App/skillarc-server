module Events
  module ScheduledCommandsExecuted
    V1 = Messages::Schema.active(
      data: Messages::Nothing,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Task,
      message_type: Messages::Types::Infrastructure::SCHEDULED_COMMAND_EXECUTED,
      version: 1
    )
  end
end
