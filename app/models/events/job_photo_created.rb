module Events
  module JobPhotoCreated
    module Data
      class V1
        extend Payload

        schema do
          id Uuid
          job_id Uuid
          photo_url String
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
