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
    end

    V1 = Messages::Schema.build(
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Job,
      message_type: Messages::Types::CHAT_MESSAGE_SENT,
      version: 1
    )
  end
end
