module Events
  module PersonApplied
    module Data
      class V1
        extend Messages::Payload

        schema do
          application_id Uuid
          seeker_first_name String
          seeker_last_name String
          seeker_email String
          seeker_phone_number Either(String, nil), default: nil
          user_id String
          job_id Uuid
          employer_name String
          employment_title String
        end
      end
    end

    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      stream: Streams::Person,
      message_type: Messages::Types::Person::PERSON_APPLIED,
      version: 1
    )
  end
end
