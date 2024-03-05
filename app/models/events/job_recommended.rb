module Events
  module JobRecommended
    module Data
      class V1
        extend Messages::Payload

        schema do
          job_id Uuid
          coach_id Uuid
        end
      end
    end

    V1 = Messages::Schema.build(
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Seeker,
      message_type: Messages::Types::Coaches::JOB_RECOMMENDED,
      version: 1
    )
    V2 = Messages::Schema.build(
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Coaches::SeekerContext,
      message_type: Messages::Types::Coaches::JOB_RECOMMENDED,
      version: 2
    )
  end
end
