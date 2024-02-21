class DbStreamReactor < DbStreamListener
  def kind
    StreamListener::Kind::REACTOR
  end

  def self.build(consumer, listener_name)
    reactor = new(consumer, listener_name)
    StreamListener.register(listener_name, reactor)
    reactor
  end

  private

  def handle_event(event)
    # TODO do the memo thing

    consumer.handle_event(event)
  end
end
