class DbStreamReactor < DbStreamListener
  def kind
    StreamListener::Kind::REACTOR
  end

  def self.build(consumer, listener_name, now: Time.zone.now)
    reactor = new(consumer, listener_name, now)
    StreamListener.register(listener_name, reactor)
    reactor
  end

  def replay; end

  private

  def initialize(consumer, listener_name, now)
    super(consumer, listener_name)
    @now = now
  end

  def default_time
    @now
  end

  def handle_message(message)
    dedup(message) do
      consumer.handle_message(message)
    end
  end

  def dedup(message)
    checksum = message.checksum
    reactor_state = ReactorMessageState.find_by(consumer_name: listener_name, message_checksum: checksum)
    return if reactor_state&.done?

    reactor_state ||= ReactorMessageState.create!(consumer_name: listener_name, message_checksum: checksum, state: ReactorMessageState::Status::NEW)
    reactor_state.with_lock do
      yield

      reactor_state.update!(state: ReactorMessageState::Status::DONE)
    end
  end
end
