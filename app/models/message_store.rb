# == Schema Information
#
# Table name: messages
#
#  id             :bigint           not null, primary key
#  data           :jsonb            not null
#  metadata       :jsonb            not null
#  occurred_at    :datetime         not null
#  stream         :text             not null
#  versioned_type :text             not null
#  message_id     :uuid             not null
#  trace_id       :uuid             not null
#
# Indexes
#
#  index_messages_on_message_id      (message_id)
#  index_messages_on_occurred_at     (occurred_at)
#  index_messages_on_stream          (stream)
#  index_messages_on_trace_id        (trace_id)
#  index_messages_on_versioned_type  (versioned_type)
#
class MessageStore < ApplicationRecord
  self.table_name = "messages"

  def message
    split = versioned_type.split(":")
    schema = MessageService.get_schema(message_type: split[0], version: split[1])

    Message.new(
      id:,
      stream: schema.stream.new(**{ schema.stream.id => aggregate_id }),
      trace_id:,
      schema:,
      data: schema.data.deserialize(data),
      metadata: schema.metadata.deserialize(metadata),
      occurred_at:
    )
  end

  def self.from_message!(message)
    if message.schema.event?

    end

    create!(
      id: message.event_id,
      stream: message.stream.id,
      trace_id: message.trace_id,
      event_type: message.schema.message_type,
      data: message.data.serialize,
      metadata: message.metadata.serialize,
      version: message.schema.version,
      occurred_at: message.occurred_at
    )
  end
end
