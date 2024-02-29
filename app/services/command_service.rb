class CommandService
  def self.create!(command_schema:, aggregate_id:, data:, trace_id:, id: SecureRandom.uuid, occurred_at: Time.zone.now, metadata: Messages::Nothing) # rubocop:disable Metrics/ParameterLists
    MessageService.create!(
      message_schema: command_schema,
      aggregate_id:,
      trace_id:,
      id:,
      occurred_at:,
      data:,
      metadata:
    )
  end
end
