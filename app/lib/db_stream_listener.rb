class DbStreamListener < StreamListener
  delegate :all_handled_events, to: :consumer
  delegate :handled_events, to: :consumer
  delegate :handled_events_sync, to: :consumer

  attr_reader :listener_name

  def id
    "db-stream-#{kind}-#{listener_name}"
  end

  def play
    events = unplayed_events

    return if events.empty?

    last_handled_event = nil

    events.each do |event|
      begin
        handle_message(event.message)
      rescue StandardError => e
        update_bookmark(last_handled_event) if last_handled_event
        raise e
      end

      last_handled_event = event
    end
    update_bookmark(last_handled_event)
  end

  def next_event
    unplayed_events.take(1).first.message
  end

  def call(*)
    play
  end

  private

  def bookmark
    ListenerBookmark.find_or_initialize_by(consumer_name: listener_name)
  end

  def unplayed_events
    Event.where("occurred_at > ?", bookmark_timestamp).order(:occurred_at)
  end

  def initialize(consumer, listener_name) # rubocop:disable Lint/MissingSuper
    @consumer = consumer
    @listener_name = listener_name
  end

  def bookmark_timestamp
    b = bookmark

    return default_time unless bookmark.id

    Event.find(b.event_id).message.occurred_at
  end

  def update_bookmark(event)
    bookmark.update!(event_id: event.id)
  end

  def default_time
    raise NoMethodError
  end

  def handle_message(*)
    raise NoMethodError
  end

  attr_reader :consumer
end
