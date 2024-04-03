module Events
  module JobOwnerAssigned
    module Data
      class V1
        extend Messages::Payload

        schema do
          job_id Uuid
          owner_email String
        end
      end
    end

    V1 = Messages::Schema.active(
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::User,
      message_type: Messages::Types::Employers::JOB_OWNER_ASSIGNED,
      version: 1
    )
  end
end
