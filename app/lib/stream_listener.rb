class StreamListener
  def initialize(consumer, listener_name)
    raise NotImplementedError
  end

  def call(event)
    raise NotImplementedError
  end

  def play
    raise NotImplementedError
  end

  def replay
    raise NotImplementedError
  end
end
