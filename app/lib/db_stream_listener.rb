class DbStreamListener < StreamListener
  delegate :handled_events, to: :consumer
  delegate :handled_events_sync, to: :consumer

  attr_reader :listener_name

  def self.build(consumer, listener_name)
    listener = new(consumer, listener_name)
    StreamListener.register(listener_name, listener)
    listener
  end

  def id
    "db-stream-listern-#{listener_name}"
  end

  def replay
    consumer.reset_for_replay

    ListenerBookmark.find_by(consumer_name: listener_name)&.destroy
    play
  end

  def play
    after_events = Event.where("occurred_at > ?", bookmark_timestamp).order(:occurred_at)

    return if after_events.empty?

    after_events.each do |event|
      handle_event(event.message, with_side_effects: true)
    end
  end

  def call(*)
    play
  end

  private

  def initialize(consumer, listener_name) # rubocop:disable Lint/MissingSuper
    @consumer = consumer
    @listener_name = listener_name
  end

  def bookmark_timestamp
    bookmark = ListenerBookmark.find_by(consumer_name: listener_name)

    return Time.zone.at(0) unless bookmark

    Event.find(bookmark.event_id).message.occurred_at
  end

  def handle_event(event, with_side_effects: false)
    consumer.handle_event(event, with_side_effects:)

    ListenerBookmark
      .find_or_initialize_by(consumer_name: listener_name)
      .update!(event_id: event.id)
  end

  attr_reader :consumer
end
