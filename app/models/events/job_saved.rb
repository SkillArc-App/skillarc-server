module Events
  module JobSaved
    V1 = Schema.new(
      data: Common::UntypedHashWrapper,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::JOB_SAVED,
      version: 1
    )
  end
end
