module Events
  module SkillLevelUpdated
    module Data
      class V1
        extend Messages::Payload

        schema do
          skill_level String
        end
      end
    end

    V1 = Messages::Schema.destroy!(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Seeker,
      message_type: Messages::Types::Coaches::SKILL_LEVEL_UPDATED,
      version: 1
    )
    V2 = Messages::Schema.inactive(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Coaches::SeekerContext,
      message_type: Messages::Types::Coaches::SKILL_LEVEL_UPDATED,
      version: 2
    )
    V3 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Person,
      message_type: Messages::Types::Coaches::SKILL_LEVEL_UPDATED,
      version: 3
    )
  end
end
