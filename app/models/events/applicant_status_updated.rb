module Events
  module ApplicantStatusUpdated
    module Reason
      class V1
        extend Concerns::Payload

        schema do
          id Uuid
          answer String
        end
      end
    end

    module Data
      class V2
        extend Concerns::Payload

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
        extend Concerns::Payload

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
          reason ArrayOf(Reason::V1)
        end
      end
    end

    V2 = Schema.build(
      data: Data::V2,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::APPLICANT_STATUS_UPDATED,
      version: 2
    )
    V3 = Schema.build(
      data: Data::V3,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::APPLICANT_STATUS_UPDATED,
      version: 3
    )
  end
end
