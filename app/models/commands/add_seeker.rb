module Commands
  module AddSeeker
    module Data
      class V1
        extend Messages::Payload

        schema do
          id Uuid
        end
      end

      class V2
        extend Messages::Payload

        schema do
          user_id Uuid
        end
      end
    end

    V1 = Messages::Schema.destroy!(
      type: Messages::COMMAND,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::User,
      message_type: Messages::Types::Seekers::ADD_SEEKER,
      version: 1
    )
    V2 = Messages::Schema.active(
      type: Messages::COMMAND,
      data: Data::V2,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Seeker,
      message_type: Messages::Types::Seekers::ADD_SEEKER,
      version: 2
    )
  end
end
