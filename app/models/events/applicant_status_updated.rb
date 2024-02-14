module Events
  module ApplicantStatusUpdated
    module Data
      class V1
        extend Payload

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
        extend Payload

        schema do
          applicant_id Uuid
          applicant_first_name String
          applicant_last_name String
          applicant_email String
          applicant_phone_number String
          profile_id Either(Uuid, nil), default: nil
          seeker_id Uuid
          user_id String
          job_id Uuid
          employer_name String
          employment_title String
          status Either(*ApplicantStatus::StatusTypes::ALL)
        end
      end
    end

    V1 = Schema.build(
      data: Data::V1,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::APPLICANT_STATUS_UPDATED,
      version: 1
    )

    V2 = Schema.build(
      data: Data::V2,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::APPLICANT_STATUS_UPDATED,
      version: 2
    )
  end
end
