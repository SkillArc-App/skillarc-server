module Events
  module PersonalExperienceAdded
    module Data
      class V1
        extend Core::Payload

        schema do
          id Uuid
          activity Either(String, nil), default: nil
          description Either(String, nil), default: nil
          start_date Either(String, nil), default: nil
          end_date Either(String, nil), default: nil
        end
      end
    end

    V1 = Core::Schema.inactive(
      type: Core::EVENT,
      data: Data::V1,
      metadata: Core::Nothing,
      aggregate: Streams::Seeker,
      message_type: MessageTypes::Person::PERSONAL_EXPERIENCE_ADDED,
      version: 1
    )
    V2 = Core::Schema.active(
      type: Core::EVENT,
      data: Data::V1,
      metadata: Core::Nothing,
      aggregate: Streams::Person,
      message_type: MessageTypes::Person::PERSONAL_EXPERIENCE_ADDED,
      version: 2
    )
  end
end
