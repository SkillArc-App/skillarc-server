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

    V1 = Messages::Schema.build(
      data: Data::V1,
      metadata: Messages::Nothing,
      message_type: Messages::Types::Seekers::SEEKER_VIEWED,
      version: 1
    )
  end
end
