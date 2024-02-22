class EventConsumer
  def handle_event(message, now: Time.zone.now) # rubocop:disable Lint/UnusedMethodArgument
    raise NoMethodError
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
