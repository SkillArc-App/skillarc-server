module Events
  module ApplicantStatusUpdated
    module Reason
      class V1
        extend Messages::Payload

        schema do
          id Uuid
          response Either(String, nil)
        end
      end

      class V2
        extend Messages::Payload

        schema do
          id Uuid
          reason_description String
          response Either(String, nil)
        end
      end
    end

    module Data
      class V1
        extend Messages::Payload

        schema do
          applicant_id Uuid
          profile_id Either(Uuid, nil), default: nil
          seeker_id Uuid
          user_id String
          job_id Uuid
          employer_name String
          employment_title String
          status Either(*ApplicantStatus::StatusTypes::ALL)
        end
      end

      class V2
        extend Messages::Payload

        schema do
          applicant_id Uuid
          applicant_first_name String
          applicant_last_name String
          applicant_email String
          applicant_phone_number Either(String, nil), default: nil
          profile_id Either(Uuid, nil), default: nil
          seeker_id Uuid
          user_id String
          job_id Uuid
          employer_name String
          employment_title String
          status Either(*ApplicantStatus::StatusTypes::ALL)
        end
      end

      class V3
        extend Messages::Payload

        schema do
          applicant_id Uuid
          applicant_first_name String
          applicant_last_name String
          applicant_email String
          applicant_phone_number Either(String, nil), default: nil
          profile_id Either(Uuid, nil), default: nil
          seeker_id Uuid
          user_id String
          job_id Uuid
          employer_name String
          employment_title String
          status Either(*ApplicantStatus::StatusTypes::ALL)
          reasons ArrayOf(Reason::V1), default: []
        end
      end

      class V4
        extend Messages::Payload

        schema do
          applicant_id Uuid
          applicant_first_name String
          applicant_last_name String
          applicant_email String
          applicant_phone_number Either(String, nil), default: nil
          profile_id Either(Uuid, nil), default: nil
          seeker_id Uuid
          user_id String
          job_id Uuid
          employer_name String
          employment_title String
          status Either(*ApplicantStatus::StatusTypes::ALL)
          reasons ArrayOf(Reason::V2), default: []
        end
      end

      class V5
        extend Messages::Payload

        schema do
          applicant_first_name String
          applicant_last_name String
          applicant_email String
          applicant_phone_number Either(String, nil), default: nil
          seeker_id Uuid
          user_id String
          job_id Uuid
          employer_name String
          employment_title String
          status Either(*ApplicantStatus::StatusTypes::ALL)
          reasons ArrayOf(Reason::V2), default: []
        end
      end
    end

    module MetaData
      class V1
        extend Messages::Payload

        schema do
          user_id Either(String, nil), default: nil
        end
      end
    end

    V1 = Messages::Schema.destroy!(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      stream: Streams::Job,
      message_type: Messages::Types::APPLICANT_STATUS_UPDATED,
      version: 1
    )

    V2 = Messages::Schema.destroy!(
      type: Messages::EVENT,
      data: Data::V2,
      metadata: Messages::Nothing,
      stream: Streams::Job,
      message_type: Messages::Types::APPLICANT_STATUS_UPDATED,
      version: 2
    )

    V3 = Messages::Schema.destroy!(
      type: Messages::EVENT,
      data: Data::V3,
      metadata: Messages::Nothing,
      stream: Streams::Job,
      message_type: Messages::Types::APPLICANT_STATUS_UPDATED,
      version: 3
    )

    V4 = Messages::Schema.destroy!(
      type: Messages::EVENT,
      data: Data::V4,
      metadata: Messages::Nothing,
      stream: Streams::Job,
      message_type: Messages::Types::APPLICANT_STATUS_UPDATED,
      version: 4
    )

    V5 = Messages::Schema.destroy!(
      type: Messages::EVENT,
      data: Data::V4,
      metadata: MetaData::V1,
      stream: Streams::Job,
      message_type: Messages::Types::APPLICANT_STATUS_UPDATED,
      version: 5
    )

    V6 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V5,
      metadata: MetaData::V1,
      stream: Streams::Application,
      message_type: Messages::Types::APPLICANT_STATUS_UPDATED,
      version: 6
    )
  end
end
