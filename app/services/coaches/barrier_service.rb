module Coaches
  class BarrierService < MessageConsumer
    def reset_for_replay
      Barrier.delete_all
    end

    def all
      Barrier.all.map do |barrier|
        {
          id: barrier.barrier_id,
          name: barrier.name
        }
      end
    end

    on_message Events::BarrierAdded::V1, :sync do |message|
      Barrier.create!(
        barrier_id: message.data.barrier_id,
        name: message.data.name
      )
    end
  end
end
