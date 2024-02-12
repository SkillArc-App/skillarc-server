module Coaches
  class BarrierService < EventConsumer
    def self.handled_events_sync
      [Events::BarrierAdded::V1].freeze
    end

    def self.handled_events
      [].freeze
    end

    def self.call(message:)
      handle_event(message)
    end

    def self.handle_event(message, *_params)
      case message.event_schema
      when Events::BarrierAdded::V1
        handle_barrier_added(message)
      end
    end

    def self.reset_for_replay
      Barrier.destroy_all
    end

    def self.all
      Barrier.all.map do |barrier|
        {
          id: barrier.barrier_id,
          name: barrier.name
        }
      end
    end

    def self.handle_barrier_added(message)
      Barrier.create!(
        barrier_id: message.data[:barrier_id],
        name: message.data[:name]
      )
    end
  end
end
