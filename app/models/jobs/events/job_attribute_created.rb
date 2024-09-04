module Jobs
  module Events
    module JobAttributeCreated
      module Data
        class V1
          extend Core::Payload

          schema do
            id Uuid
            attribute_id Uuid
            attribute_name String
            acceptible_set ArrayOf(String)
          end
        end

        class V2
          extend Core::Payload

          schema do
            job_attribute_id Uuid
            attribute_id Uuid
            acceptible_set ArrayOf(Uuid)
          end
        end
      end

      V1 = Core::Schema.inactive(
        type: Core::EVENT,
        data: Data::V1,
        metadata: Core::Nothing,
        stream: Streams::Job,
        message_type: MessageTypes::JOB_ATTRIBUTE_CREATED,
        version: 1
      )
      V2 = Core::Schema.active(
        type: Core::EVENT,
        data: Data::V2,
        metadata: Core::Nothing,
        stream: Streams::Job,
        message_type: MessageTypes::JOB_ATTRIBUTE_CREATED,
        version: 2
      )
    end
  end
end
