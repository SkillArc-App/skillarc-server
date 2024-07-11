module Events
  module MasterCertificationCreated
    module Data
      class V1
        extend Core::Payload

        schema do
          certification String
        end
      end
    end

    V1 = Core::Schema.active(
      type: Core::EVENT,
      data: Data::V1,
      metadata: Core::Nothing,
      aggregate: Streams::MasterCertification,
      message_type: MessageTypes::Qualifications::MASTER_CERTIFICATION_CREATED,
      version: 1
    )
  end
end
