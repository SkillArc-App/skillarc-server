class EventMessage
  include(ValueSemantics.for_attributes do
    id String
    aggregate_id String
    event_type Either(*Event::EventTypes::ALL)
    data Hash
    metadata Hash
    version Integer
    occurred_at ActiveSupport::TimeWithZone, coerce: true
  end)

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
