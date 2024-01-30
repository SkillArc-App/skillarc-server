class Pubsub
  def self.publish(event:)
    subscribers[event.event_type][event.version].each do |subscriber|
      subscriber.call(event:)
    end
  end

  def self.subscribe(event_schema:, subscriber:)
    subscribers[event_schema.event_type] ||= []
    subscribers[event_schema.event_type][event_schema.version] ||= []
    subscribers[event_schema.event_type][event_schema.version] << subscriber
  end

  def self.subscribers
    @subscribers ||= {}
  end

  def self.reset
    @subscribers = {}
  end
end
