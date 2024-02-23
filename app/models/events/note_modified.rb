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
    end

    V1 = Messages::Schema.build(
      data: Data::V1,
      metadata: Messages::Nothing,
      event_type: Messages::Types::NOTE_MODIFIED,
      version: 1
    )
  end
end
