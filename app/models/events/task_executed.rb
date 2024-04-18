module Events
  module TaskExecuted
    V1 = Messages::Schema.active(
      data: Messages::Nothing,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Task,
      message_type: Messages::Types::Infrastructure::TASK_EXECUTED,
      version: 1
    )
  end
end
