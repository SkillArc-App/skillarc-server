module Events
  module NoteAdded
    module Data
      class V1
        extend Messages::Payload

        schema do
          coach_id Either(Uuid, nil), default: nil
          coach_email String
          note String
          note_id Uuid
        end
      end

      class V2
        extend Messages::Payload

        schema do
          originator String
          note String
          note_id Uuid
        end
      end
    end

    V1 = Messages::Schema.inactive(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Seeker,
      message_type: Messages::Types::Coaches::NOTE_ADDED,
      version: 1
    )
    V2 = Messages::Schema.inactive(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Coaches::SeekerContext,
      message_type: Messages::Types::Coaches::NOTE_ADDED,
      version: 2
    )
    V3 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V2,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Coaches::SeekerContext,
      message_type: Messages::Types::Coaches::NOTE_ADDED,
      version: 3
    )
  end
end
