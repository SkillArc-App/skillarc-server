class EventConsumer
  def self.handle_event(message, now: Time.zone.now) # rubocop:disable Lint/UnusedMethodArgument
    raise NoMethodError
  end

  def self.handled_events
    []
  end

  def self.handled_events_sync
    []
  end

  def self.reset_for_replay
    raise NoMethodError
  end
end
