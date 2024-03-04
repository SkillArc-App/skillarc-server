module Jobs
  class JobService
    def create(params)
      job = Job.create!(
        **params,
        id: SecureRandom.uuid
      )

      EventService.create!(
        event_schema: Events::JobCreated::V2,
        aggregate_id: job.id,
        data: Events::JobCreated::Data::V2.new(
          employment_title: job.employment_title,
          employer_name: job.employer.name,
          employer_id: job.employer_id,
          benefits_description: job.benefits_description,
          responsibilities_description: job.responsibilities_description,
          location: job.location,
          employment_type: job.employment_type,
          hide_job: job.hide_job,
          schedule: job.schedule,
          work_days: job.work_days,
          requirements_description: job.requirements_description,
          industry: job.industry
        ),
        occurred_at: job.created_at
      )

      job
    end

    def update(job, params)
      job.update!(**params)

      EventService.create!(
        event_schema: Events::JobUpdated::V1,
        aggregate_id: job.id,
        data: Events::JobUpdated::Data::V1.new(
          employment_title: job.employment_title,
          benefits_description: job.benefits_description,
          responsibilities_description: job.responsibilities_description,
          location: job.location,
          employment_type: job.employment_type,
          hide_job: job.hide_job,
          schedule: job.schedule,
          work_days: job.work_days,
          requirements_description: job.requirements_description,
          industry: job.industry
        ),
        occurred_at: job.updated_at
      )

      job
    end
  end
end
