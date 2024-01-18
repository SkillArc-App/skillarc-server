module Klayvio
  class ApplicationStatusUpdated
    def call(event:)
      applicant = Applicant.find(event.data[:applicant_id])
      user = applicant.profile.user

      Klayvio.new.application_status_updated(
        application_id: event.data[:applicant_id],
        email: user.email,
        employment_title: applicant.job.employment_title,
        employer_name: applicant.job.employer.name,
        event_id: event.id,
        occurred_at: event.occurred_at,
        status: event.data[:status]
      )
    end
  end
end
