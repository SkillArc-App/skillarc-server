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

    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      stream: Streams::User,
      message_type: Messages::Types::User::JOB_UNSAVED,
      version: 1
    )
  end
end
