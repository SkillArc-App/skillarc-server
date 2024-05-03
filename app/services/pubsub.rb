class Pubsub
  attr_reader :subscribers

  NotStreamListener = Class.new(StandardError)

  def initialize(sync:)
    @sync = sync
    @subscribers = {}
  end

  def publish(schema_string:)
    if sync
      subscribers[schema_string]&.values&.each(&:play)
    else
      jobs = subscribers[schema_string]&.values&.map do |subscriber|
        ExecuteSubscriberJob.new(schema_string:, subscriber_id: subscriber.id)
      end || []

      ActiveJob.perform_all_later(jobs)
    end
  end

  def subscribe(message_schema:, subscriber:)
    raise NotStreamListener unless subscriber.class <= DbStreamListener

    schema_string = message_schema.to_s
    subscribers[schema_string] ||= {}
    subscribers[schema_string][subscriber.id] = subscriber
  end

  def execute_event(schema_string:, subscriber_id:)
    subscriber = subscribers.dig(schema_string, subscriber_id)
    subscriber.play
  end

  def reset
    @subscribers = {}
  end

  private

  attr_reader :sync
end
