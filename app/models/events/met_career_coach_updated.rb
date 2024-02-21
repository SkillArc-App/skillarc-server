module Events
  module MetCareerCoachUpdated
    V1 = Messages::Schema.build(
      data: Messages::UntypedHashWrapper,
      metadata: Messages::Nothing,
      event_type: Messages::Types::MET_CAREER_COACH_UPDATED,
      version: 1
    )
  end
end
