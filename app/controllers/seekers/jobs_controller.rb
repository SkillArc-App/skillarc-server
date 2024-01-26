module Seekers
  class JobsController < ApplicationController
    include Secured

    before_action :authorize

    def save
      EventService.create!(
        event_schema: Events::JobSaved::V1,
        aggregate_id: current_user.id,
        data: Events::Common::UntypedHashWrapper.new(
          job_id: job.id,
          employment_title: job.employment_title,
          employer_name: job.employer.name
        )
      )

      render json: { success: true }
    end

    def unsave
      EventService.create!(
        event_schema: Events::JobUnsaved::V1,
        aggregate_id: current_user.id,
        data: Events::Common::UntypedHashWrapper.new(
          job_id: job.id,
          employment_title: job.employment_title,
          employer_name: job.employer.name
        )
      )

      render json: { success: true }
    end

    private

    def job
      @job ||= Job.find(params[:job_id])
    end
  end
end
