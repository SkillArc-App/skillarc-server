class EventService
  NotEventSchemaError = Class.new(StandardError)
  NotSchemaError = Class.new(StandardError)
  SchemaAlreadyDefinedError = Class.new(StandardError)
  SchemaNotFoundError = Class.new(StandardError)

  def self.create!(event_schema:, aggregate_id:, data:, trace_id: SecureRandom.uuid, id: SecureRandom.uuid, occurred_at: Time.zone.now, metadata: Events::Common::Nothing) # rubocop:disable Metrics/ParameterLists
    raise NotEventSchemaError unless event_schema.is_a?(Events::Schema)

    message = Message.new(
      id:,
      aggregate_id:,
      occurred_at:,
      data:,
      trace_id:,
      metadata:,
      event_type: event_schema.event_type,
      version: event_schema.version
    )

    Event.from_message!(message)

    PUBSUB_SYNC.publish(message:)
    BroadcastEventJob.perform_later(message)
    message
  end

  def self.register(event_schema:)
    raise NotSchemaError unless event_schema.is_a?(Events::Schema)

    registry[event_schema.event_type] ||= {}
    Rails.logger.debug { "[Event Registry] the event_type #{event_schema.event_type} version: #{event_schema.version} was overritten" } if registry[event_schema.event_type][event_schema.version].present?
    registry[event_schema.event_type][event_schema.version] = event_schema
  end

  def self.get_schema(event_type:, version:)
    event_schema = registry.dig(event_type, version)
    raise SchemaNotFoundError, "event_type: #{event_type} version: #{version}" if event_schema.blank?

    event_schema
  end

  def self.migrate_event(event_schema:, &block)
    Event.where(event_type: event_schema.event_type, version: event_schema.version).find_each do |e|
      block.call(e.message)
    end
  end

  class << self
    private

    def registry
      @registry ||= {}
    end
  end
end
