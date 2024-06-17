module Events
  module MasterCertificationCreated
    module Data
      class V1
        extend Messages::Payload

        schema do
          certification String
        end
      end
    end

    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::MasterCertification,
      message_type: Messages::Types::Qualifications::MASTER_CERTIFICATION_CREATED,
      version: 1
    )
  end
end
