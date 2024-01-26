module Events
  module EducationExperienceUpdated
    V1 = Schema.new(
      data: Common::UntypedHashWrapper,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::EDUCATION_EXPERIENCE_UPDATED,
      version: 1
    )
  end
end
