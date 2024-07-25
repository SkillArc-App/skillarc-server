module JobOrders
  module Projectors
    class JobOrderExistingStatus < Projector
      projection_stream Streams::JobOrder

      class Projection
        extend Record

        schema do
          status Either(*JobOrders::OrderStatus::ALL)
        end
      end

      def init
        Projection.new(
          status: JobOrders::OrderStatus::NEEDS_ORDER_COUNT
        )
      end

      on_message Events::StatusUpdated::V1 do |message, accumulator|
        accumulator.with(status: message.data.status)
      end
    end
  end
end
