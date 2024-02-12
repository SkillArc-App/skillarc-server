module Klayvio
  class EducationExperienceEntered
    include DefaultStreamId

    def call(message:)
      user = User.find(message.aggregate_id)

      Klayvio.new.education_experience_entered(
        email: user.email,
        event_id: message.id,
        occurred_at: message.occurred_at
      )
    end
  end
end
