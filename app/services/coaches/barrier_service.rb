module Coaches
  class BarrierService < EventConsumer
    def handled_events_sync
      [Events::BarrierAdded::V1].freeze
    end

    def handled_events
      [].freeze
    end

    def call(message:)
      handle_message(message)
    end

    def handle_message(message, *_params)
      case message.schema
      when Events::BarrierAdded::V1
        handle_barrier_added(message)
      end
    end

    def reset_for_replay
      Barrier.destroy_all
    end

    def all
      Barrier.all.map do |barrier|
        {
          id: barrier.barrier_id,
          name: barrier.name
        }
      end
    end

    private

    def handle_barrier_added(message)
      Barrier.create!(
        barrier_id: message.data[:barrier_id],
        name: message.data[:name]
      )
    end
  end
end
