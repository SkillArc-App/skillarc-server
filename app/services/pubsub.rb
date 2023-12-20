class Pubsub
  def self.publish(event:)
    subscribers[event.event_type]&.each do |subscriber|
      subscriber.call(event: event)
    end
  end

  def self.subscribe(event:, subscriber:)
    subscribers[event] ||= []
    subscribers[event] << subscriber
  end

  private

  def self.subscribers
    @subscribers ||= {}
  end
end
