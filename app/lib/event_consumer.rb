class EventConsumer
  def self.handle_event(event, with_side_effects: false, now: Time.now)
    raise NotImplementedError
  end
end
