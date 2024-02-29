class MessageService
  NotEventSchemaError = Class.new(StandardError)
  NotSchemaError = Class.new(StandardError)
  SchemaAlreadyDefinedError = Class.new(StandardError)
  SchemaNotFoundError = Class.new(StandardError)

  def self.create!(message_schema:, aggregate_id:, data:, trace_id: SecureRandom.uuid, id: SecureRandom.uuid, occurred_at: Time.zone.now, metadata: Messages::Nothing) # rubocop:disable Metrics/ParameterLists
    raise NotEventSchemaError unless message_schema.is_a?(Messages::Schema)

    message = Message.new(
      id:,
      aggregate_id:,
      occurred_at:,
      data:,
      trace_id:,
      metadata:,
      message_type: message_schema.message_type,
      version: message_schema.version
    )

    Event.from_message!(message)

    PUBSUB_SYNC.publish(message:)
    BroadcastEventJob.perform_later(message)
    message
  end

  def self.register(message_schema:)
    raise NotSchemaError unless message_schema.is_a?(Messages::Schema)

    registry[message_schema.message_type] ||= {}
    Rails.logger.debug { "[Event Registry] the event_type #{message_schema.message_type} version: #{message_schema.version} was overritten" } if registry[message_schema.message_type][message_schema.version].present?
    registry[message_schema.message_type][message_schema.version] = message_schema
  end

  def self.get_schema(message_type:, version:)
    message_schema = registry.dig(message_type, version)
    raise SchemaNotFoundError, "event_type: #{message_type} version: #{version}" if message_schema.blank?

    message_schema
  end

  def self.migrate_event(message_schema:, &block)
    Event.where(event_type: message_schema.message_type, version: message_schema.version).find_each do |e|
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

  class << self
    private

    def registry
      @registry ||= {}
    end
  end
end
