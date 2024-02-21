class DbStreamAggregator < DbStreamListener
  def kind
    StreamListener::Kind::AGGREAGTOR
  end

  def self.build(consumer, listener_name)
    aggreagtor = new(consumer, listener_name)
    StreamListener.register(listener_name, aggreagtor)
    aggreagtor
  end

  private

  def handle_event(event)
    consumer.handle_event(event)
  end
end
