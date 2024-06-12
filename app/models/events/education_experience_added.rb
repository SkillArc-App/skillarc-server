module Events
  module EducationExperienceAdded
    module Data
      class V1
        extend Messages::Payload

        schema do
          id Uuid
          organization_name Either(String, nil), default: nil
          title Either(String, nil), default: nil
          activities Either(String, nil), default: nil
          graduation_date Either(String, nil), default: nil
          gpa Either(String, nil), default: nil
        end
      end
    end

    V1 = Messages::Schema.inactive(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      stream: Streams::Seeker,
      message_type: Messages::Types::Person::EDUCATION_EXPERIENCE_ADDED,
      version: 1
    )
    V2 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      stream: Streams::Person,
      message_type: Messages::Types::Person::EDUCATION_EXPERIENCE_ADDED,
      version: 2
    )
  end
end
