module Teams
  module Events
    module UserRemovedFromTeam
      module Data
        class V1
          extend Core::Payload

          schema do
            user_id String
          end
        end
      end

      V1 = Core::Schema.active(
        type: Core::EVENT,
        data: Data::V1,
        metadata: Core::Nothing,
        aggregate: Streams::Team,
        message_type: MessageTypes::USER_REMOVED_FROM_TEAM,
        version: 1
      )
    end
  end
end
