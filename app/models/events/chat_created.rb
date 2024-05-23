module Events
  module ChatCreated
    module Data
      class V1
        extend Messages::Payload

        schema do
          applicant_id Uuid
          profile_id Either(Uuid, nil), default: nil
          seeker_id Uuid
          user_id String
          employment_title String
        end
      end
    end

    module Data
      class V2
        extend Messages::Payload

        schema do
          employer_id Uuid
          job_id Uuid
          seeker_id Uuid
          title String
        end
      end
    end

    V1 = Messages::Schema.inactive(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Job,
      message_type: Messages::Types::Chats::CHAT_CREATED,
      version: 1
    )
    V2 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V2,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Application,
      message_type: Messages::Types::Chats::CHAT_CREATED,
      version: 2
    )
  end
end
