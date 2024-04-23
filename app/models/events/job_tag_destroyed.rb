module Events
  module JobTagDestroyed
    module Data
      class V1
        extend Messages::Payload

        schema do
          job_tag_id Uuid
        end
      end

      class V2
        extend Messages::Payload

        schema do
          job_id Uuid
          job_tag_id Uuid
          tag_id Uuid
        end
      end
    end

    V1 = Messages::Schema.inactive(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Job,
      message_type: Messages::Types::Jobs::JOB_TAG_DELETED,
      version: 1
    )
    V2 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V2,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Job,
      message_type: Messages::Types::Jobs::JOB_TAG_DELETED,
      version: 2
    )
  end
end
