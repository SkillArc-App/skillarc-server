class Pubsub
  attr_reader :subscribers

  def initialize(sync:)
    @sync = sync
    @subscribers = {}
  end

  def publish(message:)
    jobs = subscribers[message.schema]&.values&.map do |subscriber|
      resolve_event(message, subscriber)
    end&.compact || []

    ActiveJob.perform_all_later(jobs)
  end

  def subscribe(message_schema:, subscriber:)
    subscribers[message_schema] ||= {}
    subscribers[message_schema][subscriber.id] = subscriber
  end

  def execute_event(message:, subscriber_id:)
    subscriber = subscribers.dig(message.schema, subscriber_id)
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
