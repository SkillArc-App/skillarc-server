class Projector
  NotSchemaError = Class.new(StandardError)
  NotActiveSchemaError = Class.new(StandardError)
  NotCorrectAggregateError = Class.new(StandardError)
  NoAggregateError = Class.new(StandardError)
  WrongAggregatorError = Class.new(StandardError)
  AccumulatorChangedError = Class.new(StandardError)

  def init
    raise NoMethodError
  end

  def project(messages)
    accumulator = init
    accumulator_class = accumulator.class

    messages.each do |message|
      accumulator = project_message(message, accumulator)

      raise AccumulatorChangedError, "It was initially #{accumulator_class.name} and is now #{accumulator.class.name}" unless unchanged(accumulator_class, accumulator)
    end

    accumulator
  end

  def unchanged(accumulator_class, accumulator)
    if [TrueClass, FalseClass].include?(accumulator_class)
      [true, false].include?(accumulator)
    else
      accumulator.is_a?(accumulator_class)
    end
  end

  def self.projection_aggregator(aggregator)
    @aggregator = aggregator
  end

  class << self
    attr_reader :aggregator
  end

  def self.on_message(schema, &)
    raise NotSchemaError unless schema.is_a?(Messages::Schema)
    raise NotActiveSchemaError if schema.inactive?
    raise NoAggregateError, "Make sure to call projection_aggregator <aggregate class> at the top of this class" if aggregator.blank?
    raise NotCorrectAggregateError, "The on_message for #{schema} has the wrong aggregate. We need a #{aggregator}" if schema.aggregate != aggregator

    Rails.logger.error { "#{name} is subscribed to deprecated message #{schema}" } if schema.deprecated?

    method_name = "#{schema.message_type}_#{schema.version}".to_sym
    define_method(method_name, &)
  end

  private

  def project_message(message, accumulator)
    schema = message.schema
    method_name = "#{schema.message_type}_#{schema.version}".to_sym
    return accumulator unless respond_to? method_name

    send(method_name, message, accumulator)
  end

  attr_reader :aggregate
end
