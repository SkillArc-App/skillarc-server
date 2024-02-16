module Events
  class MessageSerializer < ActiveJob::Serializers::ObjectSerializer
    def serialize?(argument)
      argument.is_a?(klass)
    end

    def serialize(message)
      super(
        "id" => message.id,
        "aggregate_id" => message.aggregate_id,
        "event_type" => message.event_type,
        "data" => message.data.to_h,
        "metadata" => message.metadata.to_h,
        "version" => message.version,
        "occurred_at" => message.occurred_at,
      )
    end

    def deserialize(hash)
      schema = EventService.get_schema(event_type: hash["event_type"], version: hash["version"])

      klass.new(
        id: hash["id"],
        aggregate_id: hash["aggregate_id"],
        event_type: hash["event_type"],
        data: schema.data.from_hash(hash["data"].deep_symbolize_keys),
        metadata: schema.metadata.from_hash(hash["metadata"].deep_symbolize_keys),
        version: hash["version"],
        occurred_at: Time.zone.parse(hash["occurred_at"])
      )
    end

    def klass
      Message
    end
  end
end
