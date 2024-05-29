module Jobs
  class JobTagService
    extend MessageEmitter

    def self.create(job, tag)
      job_tag = JobTag.create!(
        id: SecureRandom.uuid,
        job:,
        tag:
      )

      message_service.create!(
        schema: Events::JobTagCreated::V1,
        job_id: job.id,
        data: {
          id: job_tag.id,
          job_id: job.id,
          tag_id: tag.id
        }
      )

      job_tag
    end

    def self.destroy(job_tag)
      job_tag.destroy!

      message_service.create!(
        schema: Events::JobTagDestroyed::V2,
        job_id: job_tag.job_id,
        data: {
          job_id: job_tag.job_id,
          job_tag_id: job_tag.id,
          tag_id: job_tag.tag_id
        }
      )
    end
  end
end
