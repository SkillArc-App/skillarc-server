module Jobs
  class JobPhotosService
    extend EventEmitter

    def self.create(job, photo_url)
      job_photo = job.job_photos.create!(
        id: SecureRandom.uuid,
        photo_url:
      )

      event_service.create!(
        event_schema: Events::JobPhotoCreated::V1,
        job_id: job.id,
        data: Events::JobPhotoCreated::Data::V1.new(
          id: job_photo.id,
          job_id: job.id,
          photo_url:
        )
      )

      job_photo
    end

    def self.destroy(job_photo)
      job_photo.destroy!

      event_service.create!(
        event_schema: Events::JobPhotoDestroyed::V1,
        job_id: job_photo.job_id,
        data: Events::JobPhotoDestroyed::Data::V1.new(
          id: job_photo.id
        )
      )
    end
  end
end
