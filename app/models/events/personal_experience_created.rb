module Events
  module PersonalExperienceCreated
    module Data
      class V1
        extend Payload

        schema do
          id Uuid
          activity Either(String, nil), default: nil
          description Either(String, nil), default: nil
          start_date Either(String, nil), default: nil
          end_date Either(String, nil), default: nil
          profile_id Either(Uuid, nil), default: nil
          seeker_id Uuid
        end
      end
    end

    V1 = Schema.build(
      data: Data::V1,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::PERSONAL_EXPERIENCE_CREATED,
      version: 1
    )
  end
end
