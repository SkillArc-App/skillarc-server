module Events
  module JobUnsaved
    V1 = Schema.new(
      data: Common::UntypedHashWrapper,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::JOB_UNSAVED,
      version: 1
    )
  end
end
