class Pubsub
  attr_reader :subscribers

  def initialize
    @subscribers = {}
  end

  def publish(event:)
    subscribers.dig(event.event_type, event.version)&.each do |subscriber|
      subscriber.call(event:)
    end
  end

  def subscribe(event_schema:, subscriber:)
    subscribers[event_schema.event_type] ||= []
    subscribers[event_schema.event_type][event_schema.version] ||= []
    subscribers[event_schema.event_type][event_schema.version] << subscriber
  end

  def reset
    @subscribers = {}
  end
end
