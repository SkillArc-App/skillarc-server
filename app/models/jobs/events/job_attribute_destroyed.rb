module Jobs
  module Events
    module JobAttributeDestroyed
      module Data
        class V1
          extend Core::Payload

          schema do
            id Uuid
          end
        end
      end

      module Data
        class V2
          extend Core::Payload

          schema do
            job_attribute_id Uuid
          end
        end
      end

      V1 = Core::Schema.inactive(
        type: Core::EVENT,
        data: Data::V1,
        metadata: Core::Nothing,
        stream: Streams::Job,
        message_type: MessageTypes::JOB_ATTRIBUTE_DESTROYED,
        version: 1
      )
      V2 = Core::Schema.active(
        type: Core::EVENT,
        data: Data::V2,
        metadata: Core::Nothing,
        stream: Streams::Job,
        message_type: MessageTypes::JOB_ATTRIBUTE_DESTROYED,
        version: 2
      )
    end
  end
end
