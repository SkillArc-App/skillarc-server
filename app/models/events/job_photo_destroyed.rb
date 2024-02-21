module Events
  module JobPhotoDestroyed
    module Data
      class V1
        extend Messages::Payload

        schema do
          id Uuid
        end
      end
    end

    V1 = Messages::Schema.build(
      data: Data::V1,
      metadata: Messages::Nothing,
      event_type: Messages::Types::JOB_PHOTO_DESTROYED,
      version: 1
    )
  end
end
