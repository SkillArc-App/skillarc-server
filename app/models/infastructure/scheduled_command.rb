# == Schema Information
#
# Table name: infastructure_scheduled_commands
#
#  id         :bigint           not null, primary key
#  execute_at :datetime         not null
#  message    :jsonb            not null
#  state      :string           not null
#  task_id    :uuid             not null
#
# Indexes
#
#  index_infastructure_scheduled_commands_on_execute_at  (execute_at)
#  index_infastructure_scheduled_commands_on_state       (state)
#  index_infastructure_scheduled_commands_on_task_id     (task_id)
#
module Infastructure
  class ScheduledCommand < ApplicationRecord
    self.table_name = "infastructure_scheduled_commands"

    module State
      ALL = [
        ENQUEUED = "enqueued".freeze,
        CANCELLED = "cancelled".freeze,
        EXECUTED = "executed".freeze
      ].freeze
    end

    scope :ready_to_execute, -> { where(state: State::ENQUEUED).where("execute_at < ?", Time.zone.now) }

    def execute!(message_service = MessageService.new)
      return unless state == State::ENQUEUED

      command = message
      schema = command.schema

      message_service.create!(
        **{
          schema:,
          data: command.data,
          trace_id: command.trace_id,
          id: command.id,
          metadata: command.metadata,
          schema.aggregate.id => message.aggregate.id
        }
      )

      update!(state: State::EXECUTED)
    end

    def cancel!
      return unless state == State::ENQUEUED

      update!(state: State::CANCELLED)
    end

    def message=(message)
      write_attribute(:message, message.serialize)
    end

    def message
      Message.deserialize(attributes["message"].deep_symbolize_keys)
    end

    validates :state, inclusion: { in: State::ALL }
  end
end
