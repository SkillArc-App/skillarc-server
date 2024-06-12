module Events
  module TaskExecuted
    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Messages::Nothing,
      metadata: Messages::Nothing,
      stream: Streams::Task,
      message_type: Messages::Types::Infrastructure::TASK_EXECUTED,
      version: 1
    )
  end
end
