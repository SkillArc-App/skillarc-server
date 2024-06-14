module Events
  module MasterSkillCreated
    module Data
      class V1
        extend Messages::Payload

        schema do
          skill String
          type Either(*MasterSkill::SkillTypes::ALL)
        end
      end
    end

    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::MasterSkill,
      message_type: Messages::Types::Qualifications::MASTER_SKILL_CREATED,
      version: 1
    )
  end
end
