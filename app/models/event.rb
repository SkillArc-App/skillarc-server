# == Schema Information
#
# Table name: events
#
#  id           :uuid             not null, primary key
#  data         :jsonb            not null
#  event_type   :string           not null
#  metadata     :jsonb            not null
#  occurred_at  :datetime         not null
#  version      :integer          default(0), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  aggregate_id :string           not null
#  trace_id     :uuid             not null
#
# Indexes
#
#  index_events_on_aggregate_id_and_version  (aggregate_id,version)
#  index_events_on_event_type                (event_type)
#
class Event < ApplicationRecord
  def message
    schema = EventService.get_schema(event_type:, version:)

    Message.new(
      id:,
      aggregate_id:,
      trace_id:,
      event_type:,
      version:,
      data: schema.data.from_hash(data),
      metadata: schema.metadata.from_hash(metadata),
      occurred_at:
    )
  end

  def self.from_message!(message)
    create!(
      id: message.id,
      aggregate_id: message.aggregate_id,
      trace_id: message.trace_id,
      event_type: message.event_type,
      data: message.data.to_h,
      metadata: message.metadata.to_h,
      version: message.version,
      occurred_at: message.occurred_at
    )
  end

  validates :event_type, presence: true, inclusion: { in: Messages::Types::ALL }

  private

  def aggregate_id
    self[:aggregate_id]
  end

  def event_type
    self[:event_type]
  end

  def data
    self[:data].deep_symbolize_keys
  end

  def metadata
    self[:metadata].deep_symbolize_keys
  end

  def version
    self[:version]
  end

  def occurred_at
    self[:occurred_at]
  end
end
