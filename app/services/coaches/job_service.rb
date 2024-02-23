module Coaches
  class JobService < EventConsumer
    def handled_events
      [
        Events::JobCreated::V1
      ].freeze
    end

    def call(message:)
      handle_message(message)
    end

    def handle_message(message, *_params)
      case message.event_schema
      when Events::JobCreated::V1
        handle_job_created(message)
      end
    end

    def all
      Job.all.map do |job|
        serialize_job(job)
      end
    end

    def reset_for_replay
      Job.destroy_all
    end

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
