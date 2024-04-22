module Klayvio
  class ApplicationStatusUpdated
    include DefaultStreamId

    def call(message:)
      Gateway.build.application_status_updated(
        application_id: message.aggregate.id,
        email: message.data.applicant_email,
        employment_title: message.data.employment_title,
        employer_name: message.data.employer_name,
        event_id: message.id,
        occurred_at: message.occurred_at,
        status: message.data.status
      )
    end
  end
end
