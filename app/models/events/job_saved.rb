module Events
  module JobSaved
    V1 = Messages::Schema.build(
      data: Messages::UntypedHashWrapper,
      metadata: Messages::Nothing,
      event_type: Event::EventTypes::JOB_SAVED,
      version: 1
    )
  end
end
