module Events
  module JobSaved
    module Data
      class V1
        extend Messages::Payload

        schema do
          job_id Uuid
          employment_title String
          employer_name String
        end
      end
    end

    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::User,
      message_type: Messages::Types::User::JOB_SAVED,
      version: 1
    )
  end
end
