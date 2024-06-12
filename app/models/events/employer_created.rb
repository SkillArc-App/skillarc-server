module Events
  module EmployerCreated
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
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      stream: Streams::Employer,
      message_type: Messages::Types::Employers::EMPLOYER_CREATED,
      version: 1
    )
  end
end
