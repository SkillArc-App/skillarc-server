module Events
  module JobTagCreated
    V1 = Schema.build(
      data: Common::UntypedHashWrapper,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::JOB_TAG_CREATED,
      version: 1
    )
  end
end
