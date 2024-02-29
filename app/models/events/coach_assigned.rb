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

    V1 = Messages::Schema.build(
      data: Data::V1,
      metadata: Messages::Nothing,
      message_type: Messages::Types::Coaches::COACH_ASSIGNED,
      version: 1
    )
  end
end
