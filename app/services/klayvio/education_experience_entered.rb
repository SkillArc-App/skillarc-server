module Klayvio
  class EducationExperienceEntered
    include DefaultStreamId

    def call(message:)
      user = Seeker.find(message.aggregate_id).user

      Gateway.build.education_experience_entered(
        email: user.email,
        event_id: message.id,
        occurred_at: message.occurred_at
      )
    end
  end
end
