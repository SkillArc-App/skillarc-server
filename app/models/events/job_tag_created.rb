module Events
  module JobTagCreated
    module Data
      class V1
        include(ValueSemantics.for_attributes do
          job_id Uuid
          tag_id Uuid
        end)

        def self.from_hash(hash)
          new(**hash)
        end
      end
    end

    V1 = Schema.build(
      data: Data::V1,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::JOB_TAG_CREATED,
      version: 1
    )
  end
end
