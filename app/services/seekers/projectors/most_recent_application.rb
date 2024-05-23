module Seekers
  module Projectors
    class MostRecentApplication < Projector
      projection_aggregator Aggregates::Seeker

      class Projection
        extend Record

        schema do
          jobs_applied_at Hash
        end

        def applied_at(job_id)
          jobs_applied_at[job_id]
        end
      end

      def init
        Projection.new(
          jobs_applied_at: {}
        )
      end

      on_message Events::SeekerApplied::V2 do |message, accumulator|
        accumulator.with(
          jobs_applied_at: accumulator.jobs_applied_at.merge(
            message.data.job_id => [accumulator.jobs_applied_at[message.data.job_id] || Time.zone.at(0), message.occurred_at].max
          )
        )
      end
    end
  end
end
