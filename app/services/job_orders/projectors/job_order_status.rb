module JobOrders
  module Projectors
    class JobOrderStatus < Projector
      projection_aggregator Aggregates::JobOrder

      class Projection
        extend Record

        schema do
          order_count Either(Integer, nil)
          candidates Hash
          not_filled? Bool()
        end

        def status
          return ClosedStatus::NOT_FILLED if not_filled?
          return ActivatedStatus::NEEDS_ORDER_COUNT if order_count.nil?
          return ClosedStatus::FILLED if hired_candidates.length >= order_count
          return StalledStatus::WAITING_ON_EMPLOYER if recommended_candidates.length + hired_candidates.length >= order_count

          ActivatedStatus::OPEN
        end

        private

        def hired_candidates
          candidates.select { |_, status| status == :hired }
        end

        def recommended_candidates
          candidates.select { |_, status| status == :recommended }
        end

        def rescinded_candidates
          candidates.select { |_, status| status == :rescinded }
        end
      end

      def init
        Projection.new(
          order_count: nil,
          candidates: {},
          not_filled?: false
        )
      end

      on_message Events::JobOrderOrderCountAdded::V1 do |message, accumulator|
        accumulator.with(order_count: message.data.order_count)
      end

      on_message Events::JobOrderNotFilled::V1 do |_, accumulator|
        accumulator.with(not_filled?: true)
      end

      on_message Events::JobOrderActivated::V1 do |_, accumulator|
        accumulator.with(not_filled?: false)
      end

      on_message Events::JobOrderCandidateAdded::V2 do |message, accumulator|
        accumulator.candidates[message.data.person_id] = :added
        accumulator
      end

      on_message Events::JobOrderCandidateRecommended::V2 do |message, accumulator|
        accumulator.candidates[message.data.person_id] = :recommended
        accumulator
      end

      on_message Events::JobOrderCandidateHired::V2 do |message, accumulator|
        accumulator.candidates[message.data.person_id] = :hired
        accumulator
      end

      on_message Events::JobOrderCandidateRescinded::V2 do |message, accumulator|
        accumulator.candidates[message.data.person_id] = :rescinded
        accumulator
      end
    end
  end
end
