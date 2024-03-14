class DbStreamAggregator < DbStreamListener
  def kind
    StreamListener::Kind::AGGREAGTOR
  end

  def self.build(consumer:, listener_name:, message_service: MessageService.new)
    aggreagtor = new(consumer:, listener_name:, message_service:)
    StreamListener.register(listener_name, aggreagtor)
    aggreagtor
  end

  def replay
    consumer.reset_for_replay

    ListenerBookmark.find_by(consumer_name: listener_name)&.destroy
    play
  end

  private

  def default_time
    Time.zone.at(0)
  end

  def handle_message(message)
    consumer.handle_message(message)
  end
end
