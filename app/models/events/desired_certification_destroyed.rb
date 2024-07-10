module Events
  module DesiredCertificationDestroyed
    module Data
      class V1
        extend Core::Payload

        schema do
          id Uuid
        end
      end
    end

    V1 = Core::Schema.active(
      type: Core::EVENT,
      data: Data::V1,
      metadata: Core::Nothing,
      aggregate: Streams::Job,
      message_type: MessageTypes::Jobs::DESIRED_CERTIFICATION_DESTROYED,
      version: 1
    )
  end
end
