module Events
  module NoteAdded
    V1 = Schema.build(
      data: Common::UntypedHashWrapper,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::NOTE_ADDED,
      version: 1
    )
  end
end
