module Commands
  module UpdateEmployer
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
      type: Messages::COMMAND,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Employer,
      message_type: Messages::Types::Employers::UPDATE_EMPLOYER,
      version: 1
    )
  end
end
