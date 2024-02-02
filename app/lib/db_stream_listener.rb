class DbStreamListener < StreamListener
  def initialize(consumer, listener_name) # rubocop:disable Lint/MissingSuper
    @consumer = consumer
    @listener_name = listener_name
  end

  delegate :handled_events, to: :consumer
  delegate :handled_events_sync, to: :consumer

  def replay
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

  def call(event:)
    handle_event(event, with_side_effects: true)
  end

  private

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

  attr_reader :consumer, :listener_name
end
