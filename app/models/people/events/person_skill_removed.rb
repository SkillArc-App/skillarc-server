module People
  module Events
    module PersonSkillRemoved
      module Data
        class V1
          extend Core::Payload

          schema do
            skill_id Uuid
            name String
            description Either(String, nil)
            type Either(*MasterSkill::SkillTypes::ALL)
          end
        end
      end

      V1 = Core::Schema.active(
        type: Core::EVENT,
        data: Data::V1,
        metadata: Core::Nothing,
        stream: Streams::Person,
        message_type: MessageTypes::PERSON_SKILL_REMOVED,
        version: 1
      )
    end
  end
end
