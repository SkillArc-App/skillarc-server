module Coaches
  class JobService
    def self.handled_events
      [
        Events::JobCreated::V1
      ].freeze
    end

    def self.handled_events_sync
      [].freeze
    end

    def self.call(event:)
      handle_event(event)
    end

    def self.handle_event(event, *_params)
      case event.event_schema
      when Events::JobCreated::V1
        handle_job_created(event)
      end
    end

    def self.all
      Job.all.map do |job|
        serialize_job(job)
      end
    end

    class << self
      private

      def handle_job_created(event)
        Job.create!(
          job_id: event.aggregate_id,
          employment_title: event.data[:employment_title]
        )
      end

      def serialize_job(job)
        {
          id: job.job_id,
          employment_title: job.employment_title
        }
      end
    end
  end
end
