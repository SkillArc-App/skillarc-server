module Users
  module Events
    module JobSaved
      module Data
        class V1
          extend Core::Payload

          schema do
            job_id Uuid
            employment_title String
            employer_name String
          end
        end
      end

      V1 = Core::Schema.active(
        type: Core::EVENT,
        data: Data::V1,
        metadata: Core::Nothing,
        stream: Streams::User,
        message_type: MessageTypes::JOB_SAVED,
        version: 1
      )
    end
  end
end
