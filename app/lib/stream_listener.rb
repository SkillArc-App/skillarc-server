class StreamListener
  module Kind
    ALL = [
      AGGREAGTOR = 'aggregator'.freeze,
      REACTOR = 'reactor'.freeze
    ].freeze
  end

  def initialize(consumer, listener_name) # rubocop:disable Lint/UnusedMethodArgument
    raise NoMethodError
  end

  def call(message) # rubocop:disable Lint/UnusedMethodArgument
    raise NoMethodError
  end

  def all_handled_events
    raise NoMethodError
  end

  def handled_events
    raise NoMethodError
  end

  def handled_events_sync
    raise NoMethodError
  end

  def id
    raise NoMethodError
  end

  def kind
    raise NoMethodError
  end

  def play
    raise NoMethodError
  end

  def replay
    raise NoMethodError
  end

  def self.register(listener_name, listener)
    registry[listener_name] = listener
  end

  def self.get_listener(listener_name)
    registry[listener_name]
  end

  class << self
    private

    def registry
      @registry ||= {}
    end
  end
end
