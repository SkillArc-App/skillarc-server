module Events
  module JobUnsaved
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

    V1 = Messages::Schema.build(
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::User,
      message_type: Messages::Types::Seekers::JOB_UNSAVED,
      version: 1
    )
  end
end
