module Events
  module PersonalExperienceCreated
    V1 = Schema.new(
      data: Common::UntypedHashWrapper,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::PERSONAL_EXPERIENCE_CREATED,
      version: 1
    )
  end
end
