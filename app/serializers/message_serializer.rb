class MessageSerializer < ActiveJob::Serializers::ObjectSerializer
  def serialize?(argument)
    argument.is_a?(klass)
  end

  def serialize(message)
    super(
      "id" => message.id,
      "trace_id" => message.trace_id,
      "aggregate" => message.aggregate.serialize,
      "schema" => message.schema.serialize,
      "data" => message.data.serialize,
      "metadata" => message.metadata.serialize,
      "occurred_at" => message.occurred_at,
    )
  end

  def deserialize(hash)
    schema = Messages::Schema.deserialize(hash["schema"])

    klass.new(
      id: hash["id"],
      trace_id: hash["trace_id"],
      aggregate: schema.aggregate.deserialize(hash["aggregate"]),
      data: schema.data.deserialize(hash["data"].deep_symbolize_keys),
      metadata: schema.metadata.deserialize(hash["metadata"].deep_symbolize_keys),
      schema:,
      occurred_at: Time.zone.parse(hash["occurred_at"])
    )
  end

  def klass
    Message
  end
end
