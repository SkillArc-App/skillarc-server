class CoachesService
  def self.handle_event(event, with_side_effects: false, now: Time.now)
    case event.event_type
    when Event::EventTypes::ROLE_ADDED
      handle_role_added(event)
    end
  end

  def self.all
    Coach.all.map do |coach|
      {
        id: coach.id,
        email: coach.email
      }
    end
  end

  private

  def self.handle_role_added(event)
    return unless event.data["role"] == "coach"

    Coach.create!(
      user_id: event.aggregate_id,
      email: event.data["email"]
    )
  end
end
