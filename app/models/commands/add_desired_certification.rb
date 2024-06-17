module Commands
  module AddDesiredCertification
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
      type: Messages::COMMAND,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Job,
      message_type: Messages::Types::Jobs::ADD_DESIRED_CERTIFICATION,
      version: 1
    )
  end
end
