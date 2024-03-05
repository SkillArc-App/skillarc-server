module Coaches
  class CoachService < MessageConsumer
    def all
      Coach.all.map do |coach|
        {
          id: coach.coach_id,
          email: coach.email
        }
      end
    end

    def reset_for_replay
      Coach.delete_all
    end

    on_message Events::RoleAdded::V1, :sync do |message|
      return unless message.data[:role] == "coach"

      Coach.create!(
        coach_id: message.data[:coach_id],
        user_id: message.aggregate_id,
        email: message.data[:email]
      )
    end
  end
end
