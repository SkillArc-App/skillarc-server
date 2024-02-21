module Coaches
  class CoachService < EventConsumer
    def self.handled_events_sync
      [Events::RoleAdded::V1].freeze
    end

    def self.handled_events
      [].freeze
    end

    def self.call(message:)
      handle_event(message)
    end

    def self.handle_event(message, now: Time.zone.now) # rubocop:disable Lint/UnusedMethodArgument
      case message.event_schema
      when Events::RoleAdded::V1
        handle_role_added(message)
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

    def self.reset_for_replay
      Coach.destroy_all
    end

    def self.handle_role_added(message)
      return unless message.data[:role] == "coach"

      Coach.create!(
        coach_id: message.data[:coach_id],
        user_id: message.aggregate_id,
        email: message.data[:email]
      )
    end
  end
end
