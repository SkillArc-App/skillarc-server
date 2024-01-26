module Events
  module SkillLevelUpdated
    V1 = Schema.new(
      data: Common::UntypedHashWrapper,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::SKILL_LEVEL_UPDATED,
      version: 1
    )
  end
end
