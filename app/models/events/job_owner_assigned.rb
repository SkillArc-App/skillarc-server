module Events
  module JobOwnerAssigned
    module Data
      class V1
        extend Concerns::Payload

        schema do
          job_id Uuid
          owner_email String
        end
      end
    end

    V1 = Messages::Schema.build(
      data: Data::V1,
      metadata: Messages::Nothing,
      event_type: Event::EventTypes::JOB_OWNER_ASSIGNED,
      version: 1
    )
  end
end
