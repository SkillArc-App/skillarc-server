module Events
  module JobCreated
    module Data
      class V1
        extend Payload

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

    V1 = Schema.build(
      data: Data::V1,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::JOB_CREATED,
      version: 1
    )
  end
end
