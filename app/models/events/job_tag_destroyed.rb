module Events
  module JobTagDestroyed
    module Data
      class V1
        extend Messages::Payload

        schema do
          job_tag_id Uuid
        end
      end
    end

    V1 = Messages::Schema.build(
      data: Data::V1,
      metadata: Messages::Nothing,
      event_type: Messages::Types::JOB_TAG_DELETED,
      version: 1
    )
  end
end
