module Coaches
  class BarrierService
    def self.handled_events
      [
        Events::BarrierAdded::V1
      ]
    end

    def self.call(event:)
      handle_event(event)
    end

    def self.handle_event(event, *_params)
      case event.event_schema
      when Events::BarrierAdded::V1
        handle_barrier_added(event)
      end
    end

    def self.all
      Barrier.all.map do |barrier|
        {
          id: barrier.barrier_id,
          name: barrier.name
        }
      end
    end

    def self.handle_barrier_added(event)
      Barrier.create!(
        barrier_id: event.data[:barrier_id],
        name: event.data[:name]
      )
    end
  end
end
