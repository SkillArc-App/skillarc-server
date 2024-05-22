module Events
  module ChatRead
    module Data
      class V1
        extend Messages::Payload

        schema do
          read_by_user_id String
        end
      end
    end

    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Application,
      message_type: Messages::Types::Chats::CHAT_READ,
      version: 1
    )
  end
end
