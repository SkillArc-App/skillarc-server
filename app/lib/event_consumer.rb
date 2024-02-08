class EventConsumer
  def self.handle_event(event, with_side_effects: false, now: Time.zone.now) # rubocop:disable Lint/UnusedMethodArgument
    raise NoMethodError
  end

  def self.handled_events
    []
  end

  def self.handled_events_sync
    []
  end
end
