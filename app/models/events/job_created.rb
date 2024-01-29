module Events
  module JobCreated
    V1 = Schema.build(
      data: Common::UntypedHashWrapper,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::JOB_CREATED,
      version: 1
    )
  end
end
