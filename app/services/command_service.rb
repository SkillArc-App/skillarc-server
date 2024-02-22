class CommandService
  def self.create!(command_schema:, aggregate_id:, data:, id: SecureRandom.uuid, occurred_at: Time.zone.now, metadata: Messages::Nothing) # rubocop:disable Metrics/ParameterLists
    EventService.create!(
      event_schema: command_schema,
      aggregate_id:,
      id:,
      occurred_at:,
      data:,
      metadata:
    )
  end
end
