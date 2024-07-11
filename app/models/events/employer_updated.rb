module Events
  module EmployerUpdated
    module Data
      class V1
        extend Core::Payload

        schema do
          name Either(String, nil)
          location Either(String, nil)
          bio Either(String, nil)
          logo_url Either(String, nil)
        end
      end
    end

    V1 = Core::Schema.active(
      type: Core::EVENT,
      data: Data::V1,
      metadata: Core::Nothing,
      aggregate: Streams::Employer,
      message_type: MessageTypes::Employers::EMPLOYER_UPDATED,
      version: 1
    )
  end
end
