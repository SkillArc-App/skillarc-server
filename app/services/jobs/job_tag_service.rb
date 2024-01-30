module Jobs
  class JobTagService
    def self.create(job, tag)
      job_tag = JobTag.create!(
        id: SecureRandom.uuid,
        job:,
        tag:
      )

      EventService.create!(
        event_schema: Events::JobTagCreated::V1,
        aggregate_id: job.id,
        data: Events::Common::UntypedHashWrapper.build(
          job_id: job.id,
          tag_id: tag.id
        ),
        occurred_at: Time.current
      )

      job_tag
    end

    def self.destroy(job_tag)
      job_tag.destroy!

      EventService.create!(
        event_schema: Events::JobTagDestroyed::V1,
        aggregate_id: job_tag.job_id,
        data: Events::Common::UntypedHashWrapper.build(
          job_id: job_tag.job_id,
          tag_id: job_tag.tag_id
        ),
        occurred_at: Time.current
      )
    end
  end
end
