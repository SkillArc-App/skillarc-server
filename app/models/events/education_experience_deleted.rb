module Events
  module EducationExperienceDeleted
    V1 = Schema.build(
      data: Common::UntypedHashWrapper,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::EDUCATION_EXPERIENCE_DELETED,
      version: 1
    )
  end
end
