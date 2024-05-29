module Events
  module JobTagCreated
    module Data
      class V1
        extend Messages::Payload

        schema do
          id Uuid
          job_id Uuid
          tag_id Uuid
        end
      end
    end

    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Job,
      message_type: Messages::Types::Jobs::JOB_TAG_CREATED,
      version: 1
    )
  end
end
