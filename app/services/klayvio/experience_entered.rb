module Klayvio
  class ExperienceEntered
    def call(event:)
      Klayvio.new.experience_entered(
        email: event.data["email"],
        event_id: event.id,
        occurred_at: event.occurred_at
      )
    end
  end
end