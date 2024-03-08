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
        job_id: job.id,
        data: Events::JobTagCreated::Data::V1.new(
          job_id: job.id,
          tag_id: tag.id
        )
      )

      job_tag
    end

    def self.destroy(job_tag)
      job_tag.destroy!

      EventService.create!(
        event_schema: Events::JobTagDestroyed::V2,
        job_id: job_tag.job_id,
        data: Events::JobTagDestroyed::Data::V2.new(
          job_id: job_tag.job_id,
          job_tag_id: job_tag.id,
          tag_id: job_tag.tag_id
        )
      )
    end
  end
end
