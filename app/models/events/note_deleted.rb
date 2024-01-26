module Events
  module NoteDeleted
    V1 = Schema.new(
      data: Common::UntypedHashWrapper,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::NOTE_DELETED,
      version: 1
    )
  end
end
