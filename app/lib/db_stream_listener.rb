class DbStreamListener < StreamListener
  delegate :all_handled_messages, to: :consumer
  delegate :handled_messages, to: :consumer
  delegate :handled_messages_sync, to: :consumer

  attr_reader :listener_name

  def id
    "db-stream-#{kind}-#{listener_name}"
  end

  def play
    bookmark.with_lock do
      events = unplayed_events

      next if events.empty?

      last_handled_event = nil

      begin
        events.each do |event|
          handle_message(event.message)
          last_handled_event = event
        end
      rescue StandardError => e
        Sentry.capture_exception(e)
      ensure
        update_bookmark(last_handled_event) if last_handled_event
      end
    end
  end

  def next_event
    unplayed_events.take(1).first.message
  end

  def call(*)
    play
  end

  private

  def bookmark
    ListenerBookmark.find_or_create_by!(consumer_name: listener_name)
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

    return default_time unless b.id
    return default_time unless b.event_id

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
