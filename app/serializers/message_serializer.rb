class MessageSerializer < ActiveJob::Serializers::ObjectSerializer
  def serialize?(argument)
    argument.is_a?(klass)
  end

  def serialize(message)
    super(
      "id" => message.id,
      "trace_id" => message.trace_id,
      "aggregate_id" => message.aggregate_id,
      "message_type" => message.schema.message_type,
      "data" => message.data.to_h,
      "metadata" => message.metadata.to_h,
      "version" => message.schema.version,
      "occurred_at" => message.occurred_at,
    )
  end

  def deserialize(hash)
    schema = EventService.get_schema(event_type: hash["message_type"], version: hash["version"])

    klass.new(
      id: hash["id"],
      trace_id: hash["trace_id"],
      aggregate_id: hash["aggregate_id"],
      data: schema.data.from_hash(hash["data"].deep_symbolize_keys),
      metadata: schema.metadata.from_hash(hash["metadata"].deep_symbolize_keys),
      schema:,
      occurred_at: Time.zone.parse(hash["occurred_at"])
    )
  end

  def klass
    Message
  end
end
