module Events
  module DesiredCertificationDestroyed
    module Data
      class V1
        extend Payload

        schema do
          id Uuid
        end
      end
    end

    V1 = Schema.build(
      data: Data::V1,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::DESIRED_CERTIFICATION_DESTROYED,
      version: 1
    )
  end
end
