module Events
  module DesiredCertificationDestroyed
    module Data
      class V1
        include(ValueSemantics.for_attributes do
          id Uuid
        end)

        def self.from_hash(hash)
          new(**hash)
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
