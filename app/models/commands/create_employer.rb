module Commands
  module CreateEmployer
    module Data
      class V1
        extend Messages::Payload

        schema do
          name String
          location String
          bio String
          logo_url String
        end
      end
    end

    V1 = Messages::Schema.active(
      type: Messages::COMMAND,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Employer,
      message_type: Messages::Types::Employers::CREATE_EMPLOYER,
      version: 1
    )
  end
end
