module Events
  module EducationExperienceUpdated
    V1 = Schema.build(
      data: Common::UntypedHashWrapper,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::EDUCATION_EXPERIENCE_UPDATED,
      version: 1
    )
  end
end
