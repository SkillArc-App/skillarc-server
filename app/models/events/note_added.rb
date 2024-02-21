module Events
  module NoteAdded
    module Data
      class V1
        extend Concerns::Payload

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
      event_type: Event::EventTypes::NOTE_ADDED,
      version: 1
    )
  end
end
