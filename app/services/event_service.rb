class EventService
  def self.create!(event_type:, aggregate_id:, data:, id: SecureRandom.uuid, occurred_at: Time.zone.now, metadata: {}, version: 1) # rubocop:disable Metrics/ParameterLists
    message = EventMessage.new(
      id:,
      event_type:,
      aggregate_id:,
      occurred_at:,
      version:,
      data: data.deep_symbolize_keys,
      metadata: metadata.deep_symbolize_keys
    )

    Event.from_message!(message)

    BroadcastEventJob.perform_later(message)
    message
  end
end
