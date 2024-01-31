module Events
  module JobPhotoCreated
    module Data
      class V1
        include(ValueSemantics.for_attributes do
          id Uuid
          job_id Uuid
          photo_url String
        end)

        def self.from_hash(hash)
          new(**hash)
        end
      end
    end

    V1 = Schema.build(
      data: Data::V1,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::JOB_PHOTO_CREATED,
      version: 1
    )
  end
end
