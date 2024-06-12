module Events
  module SeekerCreated
    module Data
      class V1
        extend Messages::Payload

        schema do
          user_id String
        end
      end
    end

    V1 = Messages::Schema.inactive(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      stream: Streams::Seeker,
      message_type: Messages::Types::Seekers::SEEKER_CREATED,
      version: 1
    )
  end
end
