class Message
  InvalidSchemaError = Class.new(StandardError)

  MESSAGE_UUID_NAMESPACE = "3e1e29c9-0fff-437c-92a7-531ca1b744b1".freeze

  delegate :id, to: :stream, prefix: true

  include(ValueSemantics.for_attributes do
    id Uuid
    stream Messages::Stream
    trace_id Uuid
    schema Messages::Schema
    data
    metadata
    occurred_at ActiveSupport::TimeWithZone, coerce: Messages::TimeZoneCoercer
  end)

  def initialize(**kwarg)
    super(**kwarg)

    raise InvalidSchemaError unless schema.stream === stream # rubocop:disable Style/CaseEquality
    raise InvalidSchemaError unless schema.data === data # rubocop:disable Style/CaseEquality
    raise InvalidSchemaError unless schema.metadata === metadata # rubocop:disable Style/CaseEquality
  end

  def stream_name
    if schema.event?
      "#{stream.class.name}|#{stream.id}"
    else
      "#{stream.class.name}:#{schema.versioned_type}|#{stream.id}"
    end
  end

  def serialize
    {
      id:,
      stream: stream.serialize,
      trace_id:,
      schema: schema.serialize,
      data: data.serialize,
      metadata: metadata.serialize,
      occurred_at:
    }
  end

  def self.deserialize(hash)
    schema = Messages::Schema.deserialize(hash[:schema])

    new(
      id: hash[:id],
      stream: schema.stream.deserialize(hash[:stream]),
      schema:,
      trace_id: hash[:trace_id],
      data: schema.data.deserialize(hash[:data]),
      metadata: schema.metadata.deserialize(hash[:metadata]),
      occurred_at: hash[:occurred_at]
    )
  end

  def ==(other)
    self.class == other.class &&
      schema == other.schema &&
      stream == other.stream &&
      id == other.id &&
      occurred_at == other.occurred_at &&
      data == other.data &&
      metadata == other.metadata
  end

  def checksum
    Digest::UUID.uuid_v3(MESSAGE_UUID_NAMESPACE, data.to_json + trace_id + schema.message_type + schema.version.to_s)
  end
end
