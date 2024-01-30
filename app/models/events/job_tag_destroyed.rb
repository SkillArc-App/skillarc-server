module Events
  module JobTagDestroyed
    V1 = Schema.build(
      data: Common::UntypedHashWrapper,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::JOB_TAG_DELETED,
      version: 1
    )
  end
end
