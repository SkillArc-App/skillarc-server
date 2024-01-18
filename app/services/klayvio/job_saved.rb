module Klayvio
  class JobSaved
    def call(event:)
      user = User.find(event.aggregate_id)

      Klayvio.new.job_saved(
        email: user.email,
        event_id: event.id,
        event_properties: {
          job_id: event.data[:job_id],
          employment_title: event.data[:employment_title],
          employer_name: event.data[:employer_name]
        },
        occurred_at: event.occurred_at
      )
    end
  end
end
