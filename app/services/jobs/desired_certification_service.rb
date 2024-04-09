module Jobs
  class DesiredCertificationService
    extend MessageEmitter

    def self.create(job, master_certification_id)
      desired_certification = job.desired_certifications.create!(id: SecureRandom.uuid, master_certification_id:)

      message_service.create!(
        schema: Events::DesiredCertificationCreated::V1,
        job_id: job.id,
        data: {
          id: desired_certification.id,
          job_id: job.id,
          master_certification_id:
    }
      )

      desired_certification
    end

    def self.destroy(desired_certification)
      desired_certification.destroy!

      message_service.create!(
        schema: Events::DesiredCertificationDestroyed::V1,
        job_id: desired_certification.job_id,
        data: {
          id: desired_certification.id
    }
      )
    end
  end
end
