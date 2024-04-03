module Events
  module NoteModified
    module Data
      class V1
        extend Messages::Payload

        schema do
          coach_id Uuid
          coach_email String
          note_id Uuid
          note String
        end
      end

      class V2
        extend Messages::Payload

        schema do
          originator String
          note_id Uuid
          note String
        end
      end
    end

    V1 = Messages::Schema.deprecated(
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Seeker,
      message_type: Messages::Types::Coaches::NOTE_MODIFIED,
      version: 1
    )
    V2 = Messages::Schema.deprecated(
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Coaches::SeekerContext,
      message_type: Messages::Types::Coaches::NOTE_MODIFIED,
      version: 2
    )
    V3 = Messages::Schema.active(
      data: Data::V2,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Coaches::SeekerContext,
      message_type: Messages::Types::Coaches::NOTE_MODIFIED,
      version: 3
    )
  end
end
