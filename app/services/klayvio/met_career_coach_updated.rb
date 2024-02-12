module Klayvio
  class MetCareerCoachUpdated
    include DefaultStreamId

    def call(message:)
      user = User.find(message.aggregate_id)

      Klayvio.new.met_with_career_coach_updated(
        email: user.email,
        event_id: message.id,
        occurred_at: message.occurred_at,
        profile_properties: {
          met_career_coach: message.data[:met_career_coach]
        }
      )
    end
  end
end
