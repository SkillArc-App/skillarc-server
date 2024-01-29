module Events
  module ExperienceCreated
    V1 = Schema.build(
      data: Common::UntypedHashWrapper,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::EXPERIENCE_CREATED,
      version: 1
    )
  end
end
