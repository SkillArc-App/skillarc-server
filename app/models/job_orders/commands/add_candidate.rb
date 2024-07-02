module JobOrders
  module Commands
    module AddCandidate
      module Data
        class V1
          extend Core::Payload

          schema do
            person_id Uuid
          end
        end
      end

      V1 = Core::Schema.active(
        type: Core::COMMAND,
        data: Data::V1,
        metadata: Core::Nothing,
        aggregate: Aggregates::JobOrder,
        message_type: MessageTypes::ADD_CANDIDATE,
        version: 1
      )
    end
  end
end
