module Events
  module TaskExecuted
    V1 = Core::Schema.active(
      type: Core::EVENT,
      data: Core::Nothing,
      metadata: Core::Nothing,
      aggregate: Aggregates::Task,
      message_type: MessageTypes::Infrastructure::TASK_EXECUTED,
      version: 1
    )
  end
end
