module Coaches
  class CoachService
    def self.call(event:)
      handle_event(event)
    end

    def self.handle_event(event, with_side_effects: false, now: Time.zone.now) # rubocop:disable Lint/UnusedMethodArgument
      case event.event_type
      when Event::EventTypes::ROLE_ADDED
        handle_role_added(event)
      end
    end

    def self.all
      Coach.all.map do |coach|
        {
          id: coach.coach_id,
          email: coach.email
        }
      end
    end

    def self.handle_role_added(event)
      return unless event.data["role"] == "coach"

      Coach.create!(
        coach_id: event.data["coach_id"],
        user_id: event.aggregate_id,
        email: event.data["email"]
      )
    end
  end
end
