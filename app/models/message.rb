class Message
  InvalidSchemaError = Class.new(StandardError)

  MESSAGE_UUID_NAMESPACE = "3e1e29c9-0fff-437c-92a7-531ca1b744b1".freeze

  delegate :id, to: :aggregate, prefix: true

  include(ValueSemantics.for_attributes do
    id Uuid
    aggregate Messages::Aggregate
    trace_id Uuid
    schema Messages::Schema
    data
    metadata
    occurred_at ActiveSupport::TimeWithZone, coerce: Messages::TimeZoneCoercer
  end)

  def initialize(**kwarg)
    super(**kwarg)

    raise InvalidSchemaError unless schema.data === data # rubocop:disable Style/CaseEquality
    raise InvalidSchemaError unless schema.metadata === metadata # rubocop:disable Style/CaseEquality
  end

  def ==(other)
    self.class == other.class &&
      schema == other.schema &&
      aggregate == other.aggregate &&
      id == other.id &&
      occurred_at == other.occurred_at &&
      data == other.data &&
      metadata == other.metadata
  end

  def checksum
    Digest::UUID.uuid_v3(MESSAGE_UUID_NAMESPACE, data.to_json + trace_id + schema.message_type + schema.version.to_s)
  end
end
