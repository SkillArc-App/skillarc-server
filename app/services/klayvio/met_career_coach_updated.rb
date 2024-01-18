module Klayvio
  class MetCareerCoachUpdated
    def call(event:)
      user = User.find(event.aggregate_id)

      Klayvio.new.met_with_career_coach_updated(
        email: user.email,
        event_id: event.id,
        occurred_at: event.occurred_at,
        profile_properties: {
          met_career_coach: event.data[:met_career_coach]
        }
      )
    end
  end
end
