class Message
  InvalidSchemaError = Class.new(StandardError)

  MESSAGE_UUID_NAMESPACE = "3e1e29c9-0fff-437c-92a7-531ca1b744b1".freeze

  include(ValueSemantics.for_attributes do
    id Uuid
    aggregate_id String
    trace_id Uuid
    event_type Either(*Messages::Types::ALL)
    data
    metadata
    version Integer
    occurred_at ActiveSupport::TimeWithZone, coerce: true
  end)

  def initialize(**kwarg)
    super(**kwarg)

    schema = event_schema

    raise InvalidSchemaError unless schema.data === data # rubocop:disable Style/CaseEquality
    raise InvalidSchemaError unless schema.metadata === metadata # rubocop:disable Style/CaseEquality
  end

  def ==(other)
    self.class == other.class &&
      event_type == other.event_type &&
      version == other.version &&
      aggregate_id == other.aggregate_id &&
      id == other.id &&
      occurred_at == other.occurred_at &&
      data == other.data &&
      metadata == other.metadata
  end

  def checksum
    Digest::UUID.uuid_v3(MESSAGE_UUID_NAMESPACE, data.to_json + trace_id + event_type + version.to_s)
  end

  def event_schema
    EventService.get_schema(event_type:, version:)
  end

  def self.coerce_occurred_at(value)
    if value.is_a?(DateTime) || value.is_a?(Time)
      value.in_time_zone
    elsif value.is_a?(String)
      Time.zone.parse(value)
    else
      value
    end
  end
end
