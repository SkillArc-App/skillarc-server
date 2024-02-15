module Events
  module JobOwnerAssigned
    module Data
      class V1
        extend Payload

        schema do
          job_id Uuid
          owner_id Uuid
        end
      end
    end

    V1 = Schema.build(
      data: Data::V1,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::JOB_OWNER_ASSIGNED,
      version: 1
    )
  end
end
