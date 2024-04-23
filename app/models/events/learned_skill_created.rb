module Events
  module LearnedSkillCreated
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

    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Job,
      message_type: Messages::Types::Jobs::LEARNED_SKILL_CREATED,
      version: 1
    )
  end
end
