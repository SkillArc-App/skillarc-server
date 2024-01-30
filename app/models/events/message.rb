module Events
  class Message
    include(ValueSemantics.for_attributes do
      id Uuid
      aggregate_id String
      event_type Either(*Event::EventTypes::ALL)
      data
      metadata
      version Integer
      occurred_at ActiveSupport::TimeWithZone, coerce: true
    end)

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
