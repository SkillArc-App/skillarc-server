module Teams
  module Projectors
    class TeamMembers < Projector
      projection_aggregator Teams::Aggregates::Team

      class Projection
        extend Record

        schema do
          team Set
        end
      end

      def init
        Projection.new(team: Set.new)
      end

      on_message Events::UserAddedToTeam::V1 do |message, accumulator|
        accumulator.team.add(message.data.user_id)
        accumulator
      end

      on_message Events::UserRemovedFromTeam::V1 do |message, accumulator|
        accumulator.team.delete(message.data.user_id)
        accumulator
      end
    end
  end
end
