module Events
  module DesiredCertificationCreated
    module Data
      class V1
        extend Concerns::Payload

        schema do
          id Uuid
          job_id Uuid
          master_certification_id Uuid
        end
      end
    end

    V1 = Schema.build(
      data: Data::V1,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::DESIRED_CERTIFICATION_CREATED,
      version: 1
    )
  end
end
