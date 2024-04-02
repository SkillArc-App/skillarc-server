module Klayvio
  class ApplicationStatusUpdated
    include DefaultStreamId

    def call(message:)
      applicant = Applicant.find(message.data[:applicant_id])
      user = applicant.seeker.user

      Gateway.build.application_status_updated(
        application_id: message.data[:applicant_id],
        email: user.email,
        employment_title: applicant.job.employment_title,
        employer_name: applicant.job.employer.name,
        event_id: message.id,
        occurred_at: message.occurred_at,
        status: message.data[:status]
      )
    end
  end
end
