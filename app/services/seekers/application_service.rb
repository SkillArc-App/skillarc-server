module Seekers
  class ApplicationService
    def self.apply(seeker:, job:, message_service:)
      message_service.create!(
        seeker_id: seeker.id,
        schema: Events::SeekerApplied::V2,
        data: {
          application_id: SecureRandom.uuid,
          seeker_first_name: seeker.first_name,
          seeker_last_name: seeker.last_name,
          seeker_email: seeker.email,
          seeker_phone_number: seeker.phone_number,
          user_id: seeker.user.id,
          job_id: job.id,
          employer_name: job.employer.name,
          employment_title: job.employment_title
        }
      )
    end
  end
end
