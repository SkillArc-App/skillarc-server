module Events
  module ProfileCreated
    module Data
      class V1
        extend Messages::Payload

        schema do
          id Uuid
          user_id String
        end
      end

      class V2
        extend Messages::Payload

        schema do
          user_id String
        end
      end
    end

    V1 = Messages::Schema.destroy!(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      stream: Streams::User,
      message_type: Messages::Types::Seekers::PROFILE_CREATED,
      version: 1
    )
  end
end
