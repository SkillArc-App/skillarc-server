module Events
  module NoteModified
    V1 = Schema.new(
      data: Common::UntypedHashWrapper,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::NOTE_MODIFIED,
      version: 1
    )
  end
end
