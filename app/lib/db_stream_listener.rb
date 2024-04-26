class DbStreamListener < StreamListener
  delegate :all_handled_messages, to: :consumer
  delegate :handled_messages, to: :consumer
  delegate :handled_messages_sync, to: :consumer

  attr_reader :listener_name, :last_error

  def id
    "db-stream-#{kind}-#{listener_name}"
  end

  def play
    error = nil

    bookmark = load_bookmark
    bookmark.with_lock do
      events = unplayed_events(bookmark)

      last_handled_event = nil

      begin
        events.each do |event|
          handle_message(event.message)
          last_handled_event = event
        end
      rescue StandardError => e
        @last_error = e
        error = e
      ensure
        update_bookmark(bookmark, last_handled_event) if last_handled_event
      end
    end

    message_service.flush
    raise error if error.present?
  end

  def next_event
    unplayed_events.take(1).first.message
  end

  def call(*)
    play
  end

  private

  def load_bookmark
    ListenerBookmark.find_or_create_by!(consumer_name: listener_name)
  end

  def unplayed_events(bookmark)
    Event.where("occurred_at > ?", bookmark_timestamp(bookmark)).order(:occurred_at)
  end

  def initialize(consumer:, listener_name:, message_service: MessageService.new) # rubocop:disable Lint/MissingSuper
    @consumer = consumer
    @consumer.message_service = message_service

    @listener_name = listener_name
    @message_service = message_service
    @last_error = nil
  end

  def bookmark_timestamp(bookmark)
    return default_time unless bookmark.id
    return default_time unless bookmark.event_id

    Event.find(bookmark.event_id).message.occurred_at
  end

  def update_bookmark(bookmark, event)
    bookmark.update!(event_id: event.id)
  end

  def default_time
    raise NoMethodError
  end

  def handle_message(message)
    consumer.handle_message(message)
  end

  attr_reader :consumer, :message_service
end
