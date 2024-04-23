module Events
  module PersonalExperienceAdded
    module Data
      class V1
        extend Messages::Payload

        schema do
          id Uuid
          activity Either(String, nil), default: nil
          description Either(String, nil), default: nil
          start_date Either(String, nil), default: nil
          end_date Either(String, nil), default: nil
        end
      end
    end

    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Seeker,
      message_type: Messages::Types::Seekers::PERSONAL_EXPERIENCE_ADDED,
      version: 1
    )
  end
end
