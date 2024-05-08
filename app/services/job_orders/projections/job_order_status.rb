module JobOrders
  module Projections
    class JobOrderStatus < Projector
      projection_aggregator Aggregates::JobOrder

      InvalidTransitionError = Class.new(StandardError)
      DoubleCountingError = Class.new(StandardError)

      class Projection
        extend Record

        schema do
          order_count Either(Integer, nil)
          hired_candidates Set
          candidates Set
          recommended_candidates Set
          rescinded_candidates Set
          not_filled? Bool()
        end

        def status
          assert_no_overlaps!

          return CloseStatus::NOT_FILLED if not_filled?
          return OpenStatus::OPEN if order_count.nil?
          return CloseStatus::FILLED if hired_candidates.length >= order_count
          return IdleStatus::WAITING_ON_EMPLOYER if recommended_candidates.length + hired_candidates.length >= order_count

          OpenStatus::OPEN
        end

        def assert_no_overlaps!
          total_count = hired_candidates.length + candidates.length + recommended_candidates.length + rescinded_candidates.length
          unique_count = (hired_candidates | candidates | recommended_candidates | rescinded_candidates).length

          raise DoubleCountingError if total_count != unique_count
        end
      end

      def init
        Projection.new(
          hired_candidates: Set[],
          order_count: nil,
          candidates: Set[],
          recommended_candidates: Set[],
          rescinded_candidates: Set[],
          not_filled?: false
        )
      end

      on_message Events::JobOrderAdded::V1 do |message, accumulator|
        accumulator.with(order_count: message.data.order_count)
      end

      on_message Events::JobOrderClosed::V1 do |message, accumulator|
        if message.data.status == CloseStatus::NOT_FILLED
          accumulator.with(not_filled?: true)
        else
          accumulator
        end
      end

      on_message Events::JobOrderActivated::V1 do |_, accumulator|
        accumulator.with(not_filled?: false)
      end

      on_message Events::JobOrderCandidateAdded::V1 do |message, accumulator|
        add_canidate(
          accumulator:,
          seeker_id: message.data.seeker_id,
          to: :candidates
        )
      end

      on_message Events::JobOrderCandidateRecommended::V1 do |message, accumulator|
        move_canidate(
          accumulator:,
          seeker_id: message.data.seeker_id,
          from: :candidates,
          to: :recommended_candidates
        )
      end

      on_message Events::JobOrderCandidateHired::V1 do |message, accumulator|
        move_canidate(
          accumulator:,
          seeker_id: message.data.seeker_id,
          from: :recommended_candidates,
          to: :hired_candidates
        )
      end

      on_message Events::JobOrderCandidateRescinded::V1 do |message, accumulator|
        move_canidate(
          accumulator:,
          seeker_id: message.data.seeker_id,
          from: :hired_candidates,
          to: :rescinded_candidates
        )
      end

      private

      def move_canidate(accumulator:, seeker_id:, to:, from:)
        accumulator = remove_canidate(accumulator:, seeker_id:, from:)
        add_canidate(accumulator:, seeker_id:, to:)
      end

      def remove_canidate(accumulator:, seeker_id:, from:)
        from_bucket = accumulator.send(from)
        raise InvalidTransitionError, "Attempted to remove seeker_id #{seeker_id} from #{from} for aggregate #{aggregate} which does not exist" if from_bucket.delete?(seeker_id).nil?

        accumulator
      end

      def add_canidate(accumulator:, seeker_id:, to:)
        to_bucket = accumulator.send(to)
        raise InvalidTransitionError, "Attempted to add seeker_id #{seeker_id} to #{to} for aggregate #{aggregate} which already occurred" if to_bucket.add?(seeker_id).nil?

        accumulator
      end
    end
  end
end
