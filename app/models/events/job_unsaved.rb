module Events
  module JobUnsaved
    V1 = Messages::Schema.build(
      data: Messages::UntypedHashWrapper,
      metadata: Messages::Nothing,
      event_type: Event::EventTypes::JOB_UNSAVED,
      version: 1
    )
  end
end
