module Klayvio
  class JobSaved
    include DefaultStreamId

    def call(message:)
      user = User.find(message.aggregate_id)

      Gateway.build.job_saved(
        email: user.email,
        event_id: message.id,
        event_properties: {
          job_id: message.data[:job_id],
          employment_title: message.data[:employment_title],
          employer_name: message.data[:employer_name]
        },
        occurred_at: message.occurred_at
      )
    end
  end
end
