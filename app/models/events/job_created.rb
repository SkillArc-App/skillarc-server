module Events
  module JobCreated
    module Data
      class V1
        extend Messages::Payload

        schema do
          employment_title String
          employer_id Uuid
          benefits_description String
          responsibilities_description Either(String, nil)
          location String
          employment_type Either(*Job::EmploymentTypes::ALL)
          hide_job Bool()
          schedule Either(String, nil)
          work_days Either(String, nil)
          requirements_description Either(String, nil)
          industry Either(ArrayOf(Either(*Job::Industries::ALL)), nil)
        end
      end

      class V2
        extend Messages::Payload

        schema do
          employment_title String
          employer_name String
          employer_id Uuid
          benefits_description String
          responsibilities_description Either(String, nil)
          location String
          employment_type Either(*Job::EmploymentTypes::ALL)
          hide_job Bool()
          schedule Either(String, nil)
          work_days Either(String, nil)
          requirements_description Either(String, nil)
          industry Either(ArrayOf(Either(*Job::Industries::ALL)), nil)
        end
      end

      class V3
        extend Messages::Payload

        schema do
          category Either(*Job::Categories::ALL)
          employment_title String
          employer_name String
          employer_id Uuid
          benefits_description String
          responsibilities_description Either(String, nil), default: nil
          location String
          employment_type Either(*Job::EmploymentTypes::ALL)
          hide_job Bool()
          schedule Either(String, nil), default: nil
          work_days Either(String, nil), default: nil
          requirements_description Either(String, nil), default: nil
          industry Either(ArrayOf(Either(*Job::Industries::ALL)), nil), default: nil
        end
      end
    end

    V1 = Messages::Schema.deprecated(
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Job,
      message_type: Messages::Types::Jobs::JOB_CREATED,
      version: 1
    )

    V2 = Messages::Schema.deprecated(
      data: Data::V2,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Job,
      message_type: Messages::Types::Jobs::JOB_CREATED,
      version: 2
    )

    V3 = Messages::Schema.active(
      data: Data::V3,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Job,
      message_type: Messages::Types::Jobs::JOB_CREATED,
      version: 3
    )
  end
end
