module Events
  module DesiredSkillCreated
    module Data
      class V1
        extend Payload

        schema do
          id Uuid
          job_id Uuid
          master_skill_id Uuid
        end
      end
    end

    V1 = Schema.build(
      data: Data::V1,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::DESIRED_SKILL_CREATED,
      version: 1
    )
  end
end
