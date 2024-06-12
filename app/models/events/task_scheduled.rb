module Events
  module TaskScheduled
    module Data
      class V1
        extend Messages::Payload

        schema do
          execute_at ActiveSupport::TimeWithZone, coerce: Messages::TimeZoneCoercer
          command Message
        end
      end
    end

    module MetaData
      class V1
        extend Messages::Payload

        schema do
          requestor_type Either(*Requestor::Kinds::ALL)
          requestor_id Either(String, nil)
        end
      end
    end

    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: MetaData::V1,
      stream: Streams::Task,
      message_type: Messages::Types::Infrastructure::TASK_SCHEDULED,
      version: 1
    )
  end
end
