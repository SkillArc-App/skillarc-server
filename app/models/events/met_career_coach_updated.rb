module Events
  module MetCareerCoachUpdated
    V1 = Messages::Schema.build(
      data: Messages::UntypedHashWrapper,
      metadata: Messages::Nothing,
      event_type: Event::EventTypes::MET_CAREER_COACH_UPDATED,
      version: 1
    )
  end
end
