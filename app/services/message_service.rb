class MessageService
  NotEventSchemaError = Class.new(StandardError)
  NotSchemaError = Class.new(StandardError)
  SchemaAlreadyDefinedError = Class.new(StandardError)
  SchemaNotFoundError = Class.new(StandardError)

  def create!(schema:, data:, trace_id: SecureRandom.uuid, id: SecureRandom.uuid, occurred_at: Time.zone.now, metadata: Messages::Nothing, **) # rubocop:disable Metrics/ParameterLists
    raise NotEventSchemaError unless schema.is_a?(Messages::Schema)

    aggregate = schema.aggregate.new(**)

    data = schema.data.new(**data) if data.is_a?(Hash)
    metadata = schema.metadata.new(**metadata) if metadata.is_a?(Hash)

    message = Message.new(
      id:,
      aggregate:,
      occurred_at:,
      data:,
      trace_id:,
      metadata:,
      schema:
    )

    Event.from_message!(message)

    messages_to_publish << message

    message
  end

  def flush
    while (message = messages_to_publish.shift)
      PUBSUB_SYNC.publish(message:)
      BroadcastEventJob.perform_later(message)
    end
  end

  def self.register(schema:)
    raise NotSchemaError unless schema.is_a?(Messages::Schema)

    registry[schema.message_type] ||= {}
    Rails.logger.debug { "[Message Registry] the event_type #{schema.message_type} version: #{schema.version} was overritten" } if registry[schema.message_type][schema.version].present?
    registry[schema.message_type][schema.version] = schema
  end

  def self.get_schema(message_type:, version:)
    schema = registry.dig(message_type, version)
    raise SchemaNotFoundError, "event_type: #{message_type} version: #{version}" if schema.blank?

    schema
  end

  def self.all_messages(schema)
    Event.where(version: schema.version, event_type: schema.message_type).map(&:message)
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
