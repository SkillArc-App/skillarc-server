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

  def handle_message(message)
    # TODO do the memo thing

    consumer.handle_message(message)
  end
end
