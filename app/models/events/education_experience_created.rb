module Events
  module EducationExperienceCreated
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
          profile_id Either(Uuid, nil), default: nil
          seeker_id Uuid
        end
      end
    end

    V1 = Messages::Schema.build(
      data: Data::V1,
      metadata: Messages::Nothing,
      message_type: Messages::Types::Seekers::EDUCATION_EXPERIENCE_CREATED,
      version: 1
    )
  end
end
