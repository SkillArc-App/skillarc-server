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

    V1 = Messages::Schema.build(
      data: Data::V1,
      metadata: Messages::Nothing,
      message_type: Messages::Types::Employers::EMPLOYER_UPDATED,
      version: 1
    )
  end
end
