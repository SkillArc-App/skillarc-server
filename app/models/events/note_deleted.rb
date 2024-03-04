module Events
  module NoteDeleted
    module Data
      class V1
        extend Messages::Payload

        schema do
          coach_id Uuid
          coach_email String
          note_id Uuid
        end
      end
    end

    V1 = Messages::Schema.build(
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Seeker,
      message_type: Messages::Types::Coaches::NOTE_DELETED,
      version: 1
    )
  end
end
