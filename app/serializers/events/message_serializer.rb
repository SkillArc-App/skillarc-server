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
        "data" => message.data,
        "metadata" => message.metadata,
        "version" => message.version,
        "occurred_at" => message.occurred_at,
      )
    end

    def deserialize(hash)
      klass.new(
        id: hash["id"],
        aggregate_id: hash["aggregate_id"],
        event_type: hash["event_type"],
        data: hash["data"].deep_symbolize_keys,
        metadata: hash["metadata"].deep_symbolize_keys,
        version: hash["version"],
        occurred_at: Time.zone.parse(hash["occurred_at"])
      )
    end

    def klass
      Message
    end
  end
end

