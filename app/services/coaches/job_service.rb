module Coaches
  class JobService < EventConsumer
    def handled_events
      [
        Events::JobCreated::V2
      ].freeze
    end

    def call(message:)
      handle_message(message)
    end

    def handle_message(message, *_params)
      case message.schema
      when Events::JobCreated::V2
        handle_job_created(message)
      end
    end

    def all
      Job.visible.map do |job|
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
        employment_title: message.data[:employment_title],
        employer_name: message.data[:employer_name],
        hide_job: message.data[:hide_job]
      )
    end

    def serialize_job(job)
      {
        id: job.job_id,
        employer_name: job.employer_name,
        employment_title: job.employment_title
      }
    end
  end
end
