module Events
  module LearnedSkillCreated
    module Data
      class V1
        extend Concerns::Payload

        schema do
          id Uuid
          job_id Uuid
          master_skill_id Uuid
        end
      end
    end

    V1 = Messages::Schema.build(
      data: Data::V1,
      metadata: Messages::Nothing,
      event_type: Event::EventTypes::LEARNED_SKILL_CREATED,
      version: 1
    )
  end
end
