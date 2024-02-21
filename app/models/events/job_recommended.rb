module Events
  module JobRecommended
    module Data
      class V1
        extend Concerns::Payload

        schema do
          job_id Uuid
          coach_id Uuid
        end
      end
    end

    V1 = Messages::Schema.build(
      data: Data::V1,
      metadata: Messages::Nothing,
      event_type: Event::EventTypes::JOB_RECOMMENDED,
      version: 1
    )
  end
end
