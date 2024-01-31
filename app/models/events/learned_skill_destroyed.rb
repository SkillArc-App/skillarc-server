module Events
  module LearnedSkillDestroyed
    module Data
      class V1
        include(ValueSemantics.for_attributes do
          id Uuid
        end)
      end
    end

    V1 = Schema.build(
      data: Data::V1,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::LEARNED_SKILL_DESTROYED,
      version: 1
    )
  end
end
