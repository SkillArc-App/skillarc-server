module Events
  module JobTagDestroyed
    module Data
      class V1
        extend Concerns::Payload

        schema do
          job_tag_id Uuid
        end
      end
    end

    V1 = Schema.build(
      data: Data::V1,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::JOB_TAG_DELETED,
      version: 1
    )
  end
end
