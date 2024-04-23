class MessageService
  NotSchemaError = Class.new(StandardError)
  NotAggregateError = Class.new(StandardError)
  SchemaAlreadyDefinedError = Class.new(StandardError)
  MessageTypeHasMultipleActiveSchemas = Class.new(StandardError)
  SchemaNotFoundError = Class.new(StandardError)
  InactiveSchemaError = Class.new(StandardError)

  def create!(schema:, data:, trace_id: SecureRandom.uuid, id: SecureRandom.uuid, occurred_at: Time.zone.now, metadata: Messages::Nothing, **) # rubocop:disable Metrics/ParameterLists
    message = build(schema:, data:, trace_id:, id:, occurred_at:, metadata:, **)
    save!(message)

    message
  end

  def build(schema:, data:, trace_id: SecureRandom.uuid, id: SecureRandom.uuid, occurred_at: Time.zone.now, metadata: Messages::Nothing, **) # rubocop:disable Metrics/ParameterLists
    raise NotSchemaError unless schema.is_a?(Messages::Schema)

    raise InactiveSchemaError, "Attempted to create message for #{schema}" if schema.inactive?

    aggregate = schema.aggregate.new(**)

    data = schema.data.new(**data) if data.is_a?(Hash)
    metadata = schema.metadata.new(**metadata) if metadata.is_a?(Hash)

    Message.new(
      id:,
      aggregate:,
      occurred_at:,
      data:,
      trace_id:,
      metadata:,
      schema:
    )
  end

  def save!(message)
    Event.from_message!(message)

    messages_to_publish << message
  end

  def flush
    while (message = messages_to_publish.shift)
      PUBSUB_SYNC.publish(message:)
      BroadcastEventJob.perform_later(message) if broadcast?
    end
  end

  def broadcast?
    !Rails.env.test?
  end

  def self.register(schema:)
    raise NotSchemaError unless schema.is_a?(Messages::Schema)

    registry[schema.message_type] ||= {}

    if schema.message_type != Messages::Types::TestingOnly::TEST_EVENT_TYPE_DONT_USE_OUTSIDE_OF_TEST
      raise SchemaAlreadyDefinedError, "The message #{schema} was overritten" if registry[schema.message_type][schema.version].present?
      raise MessageTypeHasMultipleActiveSchemas, "The message_type #{schema.message_type} has multiple active schemas" if schema.active? && registry[schema.message_type].values.any?(&:active?)
    end

    registry[schema.message_type][schema.version] = schema
  end

  def self.get_schema(message_type:, version:)
    schema = registry.dig(message_type, version)
    raise SchemaNotFoundError, "event_type: #{message_type} version: #{version}" if schema.blank?

    schema
  end

  def self.all_messages(schema)
    raise NotSchemaError unless schema.is_a?(Messages::Schema)

    Event.where(version: schema.version, event_type: schema.message_type).map(&:message)
  end

  def self.aggregate_events(aggregate)
    raise NotAggregateError unless aggregate.is_a?(Messages::Aggregate)

    Event.where(aggregate_id: aggregate.id).order(:occurred_at).map(&:message).select { |m| m.schema.type == Messages::EVENT }
  end

  def self.migrate_event(schema:, &block)
    Event.where(event_type: schema.message_type, version: schema.version).find_each do |e|
      block.call(e.message)
    end
  end

  def self.all_schemas
    registry.to_a.map do |_event_type, versions|
      versions.map do |_version, event_schema|
        event_schema
      end
    end.flatten
  end

  private

  def messages_to_publish
    @messages_to_publish ||= []
  end

  class << self
    private

    def registry
      @registry ||= {}
    end
  end
end
