module Events
  module SeekerSkillCreated
    module Data
      class V1
        extend Messages::Payload

        schema do
          skill_id Uuid
          name String
          description Either(String, nil)
          type Either(*MasterSkill::SkillTypes::ALL)
        end
      end
    end

    V1 = Messages::Schema.build(
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Seeker,
      message_type: Messages::Types::Seekers::SEEKER_SKILL_CREATED,
      version: 1
    )
  end
end
