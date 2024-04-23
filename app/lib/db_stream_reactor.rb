class DbStreamReactor < DbStreamListener
  def kind
    StreamListener::Kind::REACTOR
  end

  def self.build(consumer:, listener_name:, message_service: MessageService.new, now: Time.zone.now)
    reactor = new(consumer:, listener_name:, message_service:, now:)
    StreamListener.register(listener_name, reactor)
    reactor
  end

  def replay; end

  private

  def initialize(consumer:, listener_name:, message_service:, now:)
    super(consumer:, listener_name:, message_service:)
    @now = now
  end

  def default_time
    @now
  end
end
