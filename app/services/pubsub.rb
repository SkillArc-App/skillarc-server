class Pubsub
  attr_reader :subscribers

  def initialize(sync:)
    @sync = sync
    @subscribers = {}
  end

  def publish(message:)
    subscribers.dig(message.event_type, message.version)&.values&.each do |subscriber|
      resolve_event(message, subscriber)
    end
  end

  def subscribe(event_schema:, subscriber:)
    subscribers[event_schema.event_type] ||= {}
    subscribers[event_schema.event_type][event_schema.version] ||= {}
    subscribers[event_schema.event_type][event_schema.version][subscriber.id] = subscriber
  end

  def execute_event(message:, subscriber_id:)
    subscriber = subscribers.dig(message.event_type, message.version, subscriber_id)
    subscriber.call(message:)
  end

  def reset
    @subscribers = {}
  end

  private

  attr_reader :sync

  def resolve_event(message, subscriber)
    if sync
      subscriber.call(message:)
    else
      ExecuteSubscriberJob.perform_later(message:, subscriber_id: subscriber.id)
    end
  end
end
