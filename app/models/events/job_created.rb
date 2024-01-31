module Events
  module JobCreated
    module Data
      class V1
        include(ValueSemantics.for_attributes do
          employment_title String
          employer_id Uuid
          benefits_description String
          responsibilities_description String
          location String
          employment_type Either(*Job::EmploymentTypes::ALL)
          hide_job Bool()
          schedule String
          work_days String
          requirements_description String
          industry ArrayOf(Either(*Job::Industries::ALL))
        end)

        def self.from_hash(hash)
          new(**hash)
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
