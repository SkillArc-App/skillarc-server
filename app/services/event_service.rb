class EventService
  def self.create!(event_schema:, data:, trace_id: SecureRandom.uuid, id: SecureRandom.uuid, occurred_at: Time.zone.now, metadata: Messages::Nothing, **) # rubocop:disable Metrics/ParameterLists
    MessageService.create!(
      message_schema: event_schema,
      trace_id:,
      id:,
      occurred_at:,
      data:,
      metadata:,
      **
    )
  end
end
