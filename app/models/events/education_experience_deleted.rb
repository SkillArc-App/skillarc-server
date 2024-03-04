module Events
  module EducationExperienceDeleted
    V1 = Messages::Schema.build(
      data: Messages::UntypedHashWrapper,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Seeker,
      message_type: Messages::Types::Seekers::EDUCATION_EXPERIENCE_DELETED,
      version: 1
    )
  end
end
