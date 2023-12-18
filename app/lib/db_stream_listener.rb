class DbStreamListener < StreamListener
  def initialize(consumer, listener_name)
    @consumer = consumer
    @listener_name = listener_name

    Event.where("occurred_at <= ?", bookmark_timestamp).order(:occurred_at).each do |event|
      consumer.handle_event(event, with_side_effects: false)
    end

    after_events = Event.where("occurred_at > ?", bookmark_timestamp).order(:occurred_at)
    after_events.each do |event|
      consumer.handle_event(event, with_side_effects: true)
    end

    ListenerBookmark
      .find_or_initialize_by(consumer_name: listener_name)
      .update!(event_id: after_events.last.id)
  end

  private

  def bookmark_timestamp
    bookmark = ListenerBookmark.find_by(consumer_name: listener_name)

    return Time.at(0) unless bookmark

    Event.find(bookmark.event_id).occurred_at
  end

  attr_reader :consumer, :listener_name
end