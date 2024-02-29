class Pubsub
  attr_reader :subscribers

  def initialize(sync:)
    @sync = sync
    @subscribers = {}
  end

  def publish(message:)
    jobs = subscribers.dig(message.message_type, message.version)&.values&.map do |subscriber|
      resolve_event(message, subscriber)
    end&.compact || []

    ActiveJob.perform_all_later(jobs)
  end

  def subscribe(message_schema:, subscriber:)
    subscribers[message_schema.message_type] ||= {}
    subscribers[message_schema.message_type][message_schema.version] ||= {}
    subscribers[message_schema.message_type][message_schema.version][subscriber.id] = subscriber
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
      nil
    else
      ExecuteSubscriberJob.new(message:, subscriber_id: subscriber.id)
    end
  end
end
