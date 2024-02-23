module Events
  module DesiredSkillCreated
    module Data
      class V1
        extend Messages::Payload

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
      event_type: Messages::Types::Jobs::DESIRED_SKILL_CREATED,
      version: 1
    )
  end
end
