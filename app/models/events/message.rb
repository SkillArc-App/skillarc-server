module Events
  class Message
    InvalidSchemaError = Class.new(StandardError)

    include(ValueSemantics.for_attributes do
      id Uuid
      aggregate_id String
      trace_id Uuid
      event_type Either(*Event::EventTypes::ALL)
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
        trace_id == other.trace_id &&
        aggregate_id == other.aggregate_id &&
        id == other.id &&
        occurred_at == other.occurred_at &&
        data == other.data &&
        metadata == other.metadata
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
end
