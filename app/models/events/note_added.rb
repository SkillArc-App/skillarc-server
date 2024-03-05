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
    end

    V1 = Messages::Schema.build(
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Seeker,
      message_type: Messages::Types::Coaches::NOTE_ADDED,
      version: 1
    )
    V2 = Messages::Schema.build(
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Coaches::SeekerContext,
      message_type: Messages::Types::Coaches::NOTE_ADDED,
      version: 2
    )
  end
end
