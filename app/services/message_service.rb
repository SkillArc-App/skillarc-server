class MessageService
  NotEventSchemaError = Class.new(StandardError)
  NotSchemaError = Class.new(StandardError)
  SchemaAlreadyDefinedError = Class.new(StandardError)
  SchemaNotFoundError = Class.new(StandardError)

  def create!(message_schema:, data:, trace_id: SecureRandom.uuid, id: SecureRandom.uuid, occurred_at: Time.zone.now, metadata: Messages::Nothing, **) # rubocop:disable Metrics/ParameterLists
    raise NotEventSchemaError unless message_schema.is_a?(Messages::Schema)

    aggregate = message_schema.aggregate.new(**)

    message = Message.new(
      id:,
      aggregate:,
      occurred_at:,
      data:,
      trace_id:,
      metadata:,
      schema: message_schema
    )

    Event.from_message!(message)

    messages_to_publish << message

    message
  end

  def flush
    while peek_messages_to_publish
      shift_messages_to_publish do |message|
        PUBSUB_SYNC.publish(message:)
        BroadcastEventJob.perform_later(message)
      end
    end
  end

  def peek_messages_to_publish
    messages_to_publish.first
  end

  def shift_messages_to_publish
    message = messages_to_publish.shift

    begin
      yield(message) if block_given?
    rescue StandardError => e
      messages_to_publish.unshift(message)
      raise e
    end

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

  def self.all_messages(schema)
    Event.where(version: schema.version, event_type: schema.message_type).map(&:message)
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
