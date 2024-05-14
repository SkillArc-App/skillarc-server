module JobOrders
  module Projectors
    class JobOrderExistingStatus < Projector
      projection_aggregator Aggregates::JobOrder

      class Projection
        extend Record

        schema do
          status Either(*JobOrders::OrderStatus::ALL, nil)
        end
      end

      def init
        Projection.new(
          status: JobOrders::ActivatedStatus::NEEDS_ORDER_COUNT
        )
      end

      on_message Events::JobOrderActivated::V1 do |_, accumulator|
        accumulator.with(status: JobOrders::ActivatedStatus::OPEN)
      end

      on_message Events::JobOrderFilled::V1 do |_, accumulator|
        accumulator.with(status: JobOrders::ClosedStatus::FILLED)
      end

      on_message Events::JobOrderNotFilled::V1 do |_, accumulator|
        accumulator.with(status: JobOrders::ClosedStatus::NOT_FILLED)
      end

      on_message Events::JobOrderStalled::V1 do |message, accumulator|
        accumulator.with(status: message.data.status)
      end
    end
  end
end
