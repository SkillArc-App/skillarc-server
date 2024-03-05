module Coaches
  class JobService < MessageConsumer
    def all
      Job.visible.map do |job|
        serialize_job(job)
      end
    end

    def reset_for_replay
      Job.delete_all
    end

    on_message Events::JobCreated::V2 do |message|
      Job.create!(
        job_id: message.aggregate_id,
        employment_title: message.data[:employment_title],
        employer_name: message.data[:employer_name],
        hide_job: message.data[:hide_job]
      )
    end

    private

    def serialize_job(job)
      {
        id: job.job_id,
        employer_name: job.employer_name,
        employment_title: job.employment_title
      }
    end
  end
end
