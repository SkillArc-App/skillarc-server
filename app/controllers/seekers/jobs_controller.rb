module Seekers
  class JobsController < ApplicationController
    include Secured

    before_action :authorize

    def save
      CreateEventJob.perform_later(
        event_type: Event::EventTypes::JOB_SAVED,
        aggregate_id: current_user.id,
        data: {
          job_id: job.id,
          employment_title: job.employment_title,
          employer_name: job.employer.name
        },
        occurred_at: Time.now.utc.iso8601
      )

      render json: { success: true }
    end

    def unsave
      CreateEventJob.perform_later(
        event_type: Event::EventTypes::JOB_UNSAVED,
        aggregate_id: current_user.id,
        data: {
          job_id: job.id,
          employment_title: job.employment_title,
          employer_name: job.employer.name
        },
        occurred_at: Time.now.utc.iso8601
      )

      render json: { success: true }
    end

    private

    def job
      @job ||= Job.find(params[:job_id])
    end
  end
end
