module Events
  module ChatCreated
    module Data
      class V1
        extend Concerns::Payload

        schema do
          applicant_id Uuid
          profile_id Either(Uuid, nil), default: nil
          seeker_id Uuid
          user_id String
          employment_title String
        end
      end
    end

    V1 = Schema.build(
      data: Data::V1,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::CHAT_CREATED,
      version: 1
    )
  end
end
