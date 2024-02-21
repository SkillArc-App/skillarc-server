module Events
  module JobUpdated
    module Data
      class V1
        extend Concerns::Payload

        schema do
          employment_title Either(String, nil), default: nil
          benefits_description Either(String, nil), default: nil
          responsibilities_description Either(String, nil), default: nil
          location Either(String, nil), default: nil
          employment_type Either(*Job::EmploymentTypes::ALL, nil), default: nil
          hide_job Either(Bool(), nil), default: nil
          schedule Either(String, nil), default: nil
          work_days Either(String, nil), default: nil
          requirements_description Either(String, nil), default: nil
          industry Either(ArrayOf(Either(*Job::Industries::ALL)), nil), default: nil
        end
      end
    end

    V1 = Messages::Schema.build(
      data: Data::V1,
      metadata: Messages::Nothing,
      event_type: Event::EventTypes::JOB_UPDATED,
      version: 1
    )
  end
end
