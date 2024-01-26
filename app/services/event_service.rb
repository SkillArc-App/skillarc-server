class EventService
  NotEventSchemaError = Class.new(StandardError)
  InvalidSchemaError = Class.new(StandardError)

  def self.create!(event_schema:, aggregate_id:, data:, id: SecureRandom.uuid, occurred_at: Time.zone.now, metadata: {}) # rubocop:disable Metrics/ParameterLists
    raise NotEventSchemaError unless event_schema.is_a?(Events::Schema)

    raise InvalidSchemaError unless event_schema.data === data # rubocop:disable Style/CaseEquality
    raise InvalidSchemaError unless event_schema.metadata === metadata # rubocop:disable Style/CaseEquality

    message = Events::Message.new(
      id:,
      aggregate_id:,
      occurred_at:,
      data: data.to_h,
      metadata: metadata.to_h,
      event_type: event_schema.event_type,
      version: event_schema.version
    )

    Event.from_message!(message)

    BroadcastEventJob.perform_later(message)
    message
  end
end
