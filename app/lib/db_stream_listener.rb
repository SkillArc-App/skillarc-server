class DbStreamListener < StreamListener
  delegate :handled_events, to: :consumer
  delegate :handled_events_sync, to: :consumer

  attr_reader :listener_name

  def id
    "db-stream-#{kind}-#{listener_name}"
  end

  def replay
    consumer.reset_for_replay

    ListenerBookmark.find_by(consumer_name: listener_name)&.destroy
    play
  end

  def play
    events = unplayed_events

    return if events.empty?

    events.each do |event|
      handle_message(event.message)
      update_bookmark(event)
    end
  end

  def next_event
    unplayed_events.take(1).first.message
  end

  def call(*)
    play
  end

  private

  def unplayed_events
    Event.where("occurred_at > ?", bookmark_timestamp).order(:occurred_at)
  end

  def initialize(consumer, listener_name) # rubocop:disable Lint/MissingSuper
    @consumer = consumer
    @listener_name = listener_name
  end

  def bookmark_timestamp
    bookmark = ListenerBookmark.find_by(consumer_name: listener_name)

    return Time.zone.at(0) unless bookmark

    Event.find(bookmark.event_id).message.occurred_at
  end

  def update_bookmark(event)
    ListenerBookmark
      .find_or_initialize_by(consumer_name: listener_name)
      .update!(event_id: event.id)
  end

  def handle_message(*)
    raise NoMethodError
  end

  attr_reader :consumer
end
