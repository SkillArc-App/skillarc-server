module Events
  module EmployerUpdated
    module Data
      class V1
        extend Messages::Payload

        schema do
          name Either(String, nil)
          location Either(String, nil)
          bio Either(String, nil)
          logo_url Either(String, nil)
        end
      end
    end

    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      stream: Streams::Employer,
      message_type: Messages::Types::Employers::EMPLOYER_UPDATED,
      version: 1
    )
  end
end
