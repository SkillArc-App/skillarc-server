class EventService
  delegate :flush, to: :message_service

  def initialize(message_service: MessageService.new)
    @message_service = message_service
  end

  def create!(event_schema:, data:, trace_id: SecureRandom.uuid, id: SecureRandom.uuid, occurred_at: Time.zone.now, metadata: Messages::Nothing, **) # rubocop:disable Metrics/ParameterLists
    message_service.create!(
      message_schema: event_schema,
      trace_id:,
      id:,
      occurred_at:,
      data:,
      metadata:,
      **
    )
  end

  private

  attr_reader :message_service
end
