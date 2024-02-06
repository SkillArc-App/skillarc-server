module Events
  module ApplicantStatusUpdated
    module Data
      class V1
        extend Payload

        schema do
          applicant_id Uuid
          profile_id Uuid
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
  end
end
