module Events
  module CoachAssigned
    module Data
      class V1
        extend Concerns::Payload

        schema do
          coach_id Uuid
          email String
        end
      end
    end

    V1 = Messages::Schema.build(
      data: Data::V1,
      metadata: Messages::Nothing,
      event_type: Event::EventTypes::COACH_ASSIGNED,
      version: 1
    )
  end
end
