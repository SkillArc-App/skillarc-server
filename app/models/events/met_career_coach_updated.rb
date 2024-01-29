module Events
  module MetCareerCoachUpdated
    V1 = Schema.build(
      data: Common::UntypedHashWrapper,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::MET_CAREER_COACH_UPDATED,
      version: 1
    )
  end
end
