module Events
  module ChatMessageSent
    module Data
      class V1
        extend Messages::Payload

        schema do
          applicant_id Uuid
          profile_id Either(Uuid, nil), default: nil
          seeker_id Uuid
          from_user_id String
          employer_name String
          employment_title String
          message String
        end
      end

      class V2
        extend Messages::Payload

        schema do
          from_name String
          from_user_id Either(String, nil)
          message String
        end
      end
    end

    V1 = Messages::Schema.inactive(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      stream: Streams::Job,
      message_type: Messages::Types::Chats::CHAT_MESSAGE_SENT,
      version: 1
    )
    V2 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V2,
      metadata: Messages::Nothing,
      stream: Streams::Application,
      message_type: Messages::Types::Chats::CHAT_MESSAGE_SENT,
      version: 2
    )
  end
end
