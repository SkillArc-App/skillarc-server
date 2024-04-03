module Events
  module DesiredCertificationCreated
    module Data
      class V1
        extend Messages::Payload

        schema do
          id Uuid
          job_id Uuid
          master_certification_id Uuid
        end
      end
    end

    V1 = Messages::Schema.active(
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Job,
      message_type: Messages::Types::Jobs::DESIRED_CERTIFICATION_CREATED,
      version: 1
    )
  end
end
