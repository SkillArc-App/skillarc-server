class MessageConsumer
  def handle_message(message, now: Time.zone.now) # rubocop:disable Lint/UnusedMethodArgument
    raise NoMethodError
  end

  def all_handled_messages
    handled_messages + handled_messages_sync
  end

  def handled_messages
    []
  end

  def handled_messages_sync
    []
  end

  def reset_for_replay
    raise NoMethodError
  end
end
