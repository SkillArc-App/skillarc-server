module Jobs
  class JobPhotosService
    extend MessageEmitter

    def self.create(job, photo_url)
      job_photo = job.job_photos.create!(
        id: SecureRandom.uuid,
        photo_url:
      )

      message_service.create!(
        schema: Events::JobPhotoCreated::V1,
        job_id: job.id,
        data: {
          id: job_photo.id,
          job_id: job.id,
          photo_url:
    }
      )

      job_photo
    end

    def self.destroy(job_photo)
      job_photo.destroy!

      message_service.create!(
        schema: Events::JobPhotoDestroyed::V1,
        job_id: job_photo.job_id,
        data: {
          id: job_photo.id
    }
      )
    end
  end
end
