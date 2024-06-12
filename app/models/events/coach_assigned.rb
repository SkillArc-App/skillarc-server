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

      class V2
        extend Messages::Payload

        schema do
          coach_id Uuid
        end
      end
    end

    V1 = Messages::Schema.destroy!(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      stream: Streams::Seeker,
      message_type: Messages::Types::Coaches::COACH_ASSIGNED,
      version: 1
    )
    V2 = Messages::Schema.inactive(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      stream: Streams::Coaches::SeekerContext,
      message_type: Messages::Types::Coaches::COACH_ASSIGNED,
      version: 2
    )
    V3 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V2,
      metadata: Messages::Nothing,
      stream: Streams::Person,
      message_type: Messages::Types::Coaches::COACH_ASSIGNED,
      version: 3
    )
  end
end
