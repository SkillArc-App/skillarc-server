module Events
  module SeekerCreated
    module Data
      class V1
        extend Messages::Payload

        schema do
          id Uuid
          user_id String
        end
      end
    end

    V1 = Messages::Schema.build(
      data: Data::V1,
      metadata: Messages::Nothing,
      event_type: Messages::Types::Seekers::SEEKER_CREATED,
      version: 1
    )
  end
end
