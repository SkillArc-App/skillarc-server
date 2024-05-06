module Events
  module CoachAdded
    module Data
      class V1
        extend Messages::Payload

        schema do
          coach_id Uuid
          email String
        end
      end
    end

    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::User,
      message_type: Messages::Types::Coaches::COACH_ADDED,
      version: 1
    )
  end
end
