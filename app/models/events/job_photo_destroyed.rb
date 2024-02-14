module Events
  module JobPhotoDestroyed
    module Data
      class V1
        extend Concerns::Payload

        schema do
          id Uuid
        end
      end
    end

    V1 = Schema.build(
      data: Data::V1,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::JOB_PHOTO_DESTROYED,
      version: 1
    )
  end
end
