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

    V1 = Messages::Schema.active(
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::User,
      message_type: Messages::Types::Seekers::SEEKER_CREATED,
      version: 1
    )
  end
end
