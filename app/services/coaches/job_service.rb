module Coaches
  class JobService < EventConsumer
    def self.handled_events
      [
        Events::JobCreated::V1
      ].freeze
    end

    def self.call(message:)
      handle_event(message)
    end

    def self.handle_event(message, *_params)
      case message.event_schema
      when Events::JobCreated::V1
        handle_job_created(message)
      end
    end

    def self.all
      Job.all.map do |job|
        serialize_job(job)
      end
    end

    def self.reset_for_replay
      Job.destroy_all
    end

    class << self
      private

      def handle_job_created(message)
        Job.create!(
          job_id: message.aggregate_id,
          employment_title: message.data[:employment_title]
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
