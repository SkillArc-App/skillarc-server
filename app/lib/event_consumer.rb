class EventConsumer
  def handle_message(message, now: Time.zone.now) # rubocop:disable Lint/UnusedMethodArgument
    raise NoMethodError
  end

  def all_handled_events
    handled_events + handled_events_sync
  end

  def handled_events
    []
  end

  def handled_events_sync
    []
  end

  def reset_for_replay
    raise NoMethodError
  end
end
