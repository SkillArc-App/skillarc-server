module Jobs
  class JobService
    def create(params)
      job = Job.create!(
        **params,
        id: SecureRandom.uuid
      )

      EventService.create!(
        event_schema: Events::JobCreated::V1,
        aggregate_id: job.id,
        data: Events::Common::UntypedHashWrapper.build(
          employment_title: job.employment_title,
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
    end
  end
end
