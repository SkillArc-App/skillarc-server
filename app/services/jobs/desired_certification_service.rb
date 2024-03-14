module Jobs
  class DesiredCertificationService
    extend EventEmitter

    def self.create(job, master_certification_id)
      desired_certification = job.desired_certifications.create!(id: SecureRandom.uuid, master_certification_id:)

      event_service.create!(
        event_schema: Events::DesiredCertificationCreated::V1,
        job_id: job.id,
        data: Events::DesiredCertificationCreated::Data::V1.new(
          id: desired_certification.id,
          job_id: job.id,
          master_certification_id:
        )
      )

      desired_certification
    end

    def self.destroy(desired_certification)
      desired_certification.destroy!

      event_service.create!(
        event_schema: Events::DesiredCertificationDestroyed::V1,
        job_id: desired_certification.job_id,
        data: Events::DesiredCertificationDestroyed::Data::V1.new(
          id: desired_certification.id
        )
      )
    end
  end
end
