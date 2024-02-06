module Seekers
  class JobsController < ApplicationController
    include Secured

    before_action :set_current_user, only: [:index]
    before_action :authorize, only: [:save, :unsave]

    def index
      jobs = Jobs::SearchService.new(
        search_terms: params[:search_terms] || params[:utm_term],
        industries: params[:industries],
        tags: params[:tags]
      ).relevant_jobs(user: current_user, utm_source: params[:utm_source])

      render json: Jobs::JobBlueprint.render(jobs, view: :seeker, user: current_user)
    end

    def save
      EventService.create!(
        event_schema: Events::JobSaved::V1,
        aggregate_id: current_user.id,
        data: Events::Common::UntypedHashWrapper.build(
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
        data: Events::Common::UntypedHashWrapper.build(
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
