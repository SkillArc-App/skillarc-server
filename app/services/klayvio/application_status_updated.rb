module Klayvio
  class ApplicationStatusUpdated
    def call(event:)
      user = Applicant.find(event.data["applicant_id"]).profile.user

      Klayvio.new.application_status_updated(
        application_id: event.data["applicant_id"],
        email: user.email,
        event_id: event.id,
        occurred_at: event.occurred_at,
        status: event.data["status"]
      )
    end
  end
end