module Events
  module ChatMessageSent
    module Data
      class V1
        extend Payload

        schema do
          applicant_id Uuid
          profile_id Uuid
          seeker_id Uuid
          from_user_id Uuid
          employer_name String
          employment_title String
          message String
        end
      end
    end

    V1 = Schema.build(
      data: Data::V1,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::CHAT_MESSAGE_SENT,
      version: 1
    )
  end
end
