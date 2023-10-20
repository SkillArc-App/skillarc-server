module Klayvio
  class EducationExperienceEntered
    def call(event:)
      user = User.find(event.aggregate_id)

      Klayvio.new.education_experience_entered(
        email: user.email,
        event_id: event.id,
        occurred_at: event.occurred_at
      )
    end
  end
end