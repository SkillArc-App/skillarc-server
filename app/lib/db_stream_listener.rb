class DbStreamListener < StreamListener
  delegate :all_handled_messages, to: :consumer
  delegate :handled_messages, to: :consumer
  delegate :handled_messages_sync, to: :consumer

  attr_reader :listener_name

  def id
    "db-stream-#{listener_name}"
  end

  def self.build(consumer:, listener_name:, now: Time.zone.now)
    listener = new(consumer:, listener_name:, now:)
    StreamListener.register(listener_name, listener)
    listener
  end

  def play
    bookmark = load_bookmark
    bookmark.with_lock do
      events = unplayed_messages(bookmark)

      last_handled_event = nil

      events.each do |event|
        handle_message(event.message)
        last_handled_event = event
      end

      update_bookmark(bookmark, last_handled_event) if last_handled_event
    end

    consumer.flush
  end

  def replay
    return unless consumer.can_replay?

    consumer.reset_for_replay

    ListenerBookmark.find_by(consumer_name: listener_name)&.destroy
    play
  end

  def next_message
    bookmark = load_bookmark
    unplayed_messages(bookmark).take(1).first.message
  end

  private

  def load_bookmark
    ListenerBookmark.find_or_create_by!(consumer_name: listener_name)
  end

  def unplayed_messages(bookmark)
    Event.where("occurred_at > ?", bookmark_timestamp(bookmark)).order(:occurred_at)
  end

  def initialize(consumer:, listener_name:, now:) # rubocop:disable Lint/MissingSuper
    @consumer = consumer
    @listener_name = listener_name
    @default_time = consumer.can_replay? ? Time.zone.at(0) : now
  end

  def bookmark_timestamp(bookmark)
    return bookmark.current_timestamp if bookmark.current_timestamp.present?
    return default_time unless bookmark.id
    return default_time unless bookmark.event_id

    Event.find(bookmark.event_id).message.occurred_at
  end

  def update_bookmark(bookmark, event)
    bookmark.update!(
      event_id: event.id,
      current_timestamp: event.message.occurred_at
    )
  end

  attr_reader :default_time, :consumer

  def handle_message(message)
    consumer.handle_message(message)
  end
end
