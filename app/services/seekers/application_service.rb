module Seekers
  class ApplicationService
    def self.apply(seeker:, job:, message_service:)
      aggregate = Aggregates::Seeker.new(seeker_id: seeker.id)
      messages = MessageService.aggregate_events(aggregate)

      most_recent_applicaiton = Projectors::MostRecentApplication.new.project(messages).applied_at(job.id)

      return if most_recent_applicaiton.present?

      user = seeker.user

      message_service.create!(
        aggregate:,
        schema: Events::SeekerApplied::V2,
        data: {
          application_id: SecureRandom.uuid,
          seeker_first_name: user.first_name,
          seeker_last_name: user.last_name,
          seeker_email: user.email,
          seeker_phone_number: user.phone_number,
          user_id: user.id,
          job_id: job.id,
          employer_name: job.employer.name,
          employment_title: job.employment_title
        }
      )
    end
  end
end
