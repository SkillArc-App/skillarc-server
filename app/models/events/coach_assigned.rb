module Events
  module CoachAssigned
    module Data
      class V1
        extend Messages::Payload

        schema do
          coach_id Uuid
          email String
        end
      end
    end

    V1 = Messages::Schema.deprecated(
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Seeker,
      message_type: Messages::Types::Coaches::COACH_ASSIGNED,
      version: 1
    )
    V2 = Messages::Schema.active(
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Coaches::SeekerContext,
      message_type: Messages::Types::Coaches::COACH_ASSIGNED,
      version: 2
    )
  end
end
