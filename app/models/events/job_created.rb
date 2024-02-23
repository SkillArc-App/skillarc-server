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
    end

    V1 = Messages::Schema.build(
      data: Data::V1,
      metadata: Messages::Nothing,
      event_type: Messages::Types::Jobs::JOB_CREATED,
      version: 1
    )
  end
end
