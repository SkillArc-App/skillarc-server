module Events
  module SkillLevelUpdated
    module Data
      class V1
        extend Concerns::Payload

        schema do
          skill_level String
        end
      end
    end

    V1 = Schema.build(
      data: Data::V1,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::SKILL_LEVEL_UPDATED,
      version: 1
    )
  end
end
