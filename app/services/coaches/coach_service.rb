module Coaches
  class CoachService < MessageConsumer
    def handled_messages_sync
      [Events::RoleAdded::V1].freeze
    end

    def handled_messages
      [].freeze
    end

    def call(message:)
      handle_message(message)
    end

    def handle_message(message, now: Time.zone.now) # rubocop:disable Lint/UnusedMethodArgument
      case message.schema
      when Events::RoleAdded::V1
        handle_role_added(message)
      end
    end

    def all
      Coach.all.map do |coach|
        {
          id: coach.coach_id,
          email: coach.email
        }
      end
    end

    def reset_for_replay
      Coach.destroy_all
    end

    private

    def handle_role_added(message)
      return unless message.data[:role] == "coach"

      Coach.create!(
        coach_id: message.data[:coach_id],
        user_id: message.aggregate_id,
        email: message.data[:email]
      )
    end
  end
end
