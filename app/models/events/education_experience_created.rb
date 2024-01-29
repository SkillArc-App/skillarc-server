module Events
  module EducationExperienceCreated
    V1 = Schema.build(
      data: Common::UntypedHashWrapper,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::EDUCATION_EXPERIENCE_CREATED,
      version: 1
    )
  end
end
