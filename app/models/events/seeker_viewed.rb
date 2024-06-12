module Events
  module SeekerViewed
    module Data
      class V1
        extend Messages::Payload

        schema do
          seeker_id Uuid
        end
      end
    end

    V1 = Messages::Schema.inactive(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      stream: Streams::User,
      message_type: Messages::Types::Seekers::SEEKER_VIEWED,
      version: 1
    )
  end
end
