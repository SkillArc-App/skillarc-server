module Events
  module EducationExperienceDeleted
    V1 = Schema.new(
      data: Common::UntypedHashWrapper,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::EDUCATION_EXPERIENCE_DELETED,
      version: 1
    )
  end
end
