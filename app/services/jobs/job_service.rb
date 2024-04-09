module Jobs
  class JobService
    include MessageEmitter

    def create(params)
      job = Job.create!(
        **params,
        id: SecureRandom.uuid
      )

      message_service.create!(
        schema: Events::JobCreated::V3,
        job_id: job.id,
        data: {
          category: job.category,
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
        },
        occurred_at: job.created_at
      )

      job
    end

    def update(job, params)
      job.update!(**params)

      message_service.create!(
        schema: Events::JobUpdated::V2,
        job_id: job.id,
        data: {
          category: job.category,
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
        },
        occurred_at: job.updated_at
      )

      job
    end
  end
end
