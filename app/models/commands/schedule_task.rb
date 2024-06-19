module Commands
  module ScheduleTask
    module Data
      class V1
        extend Core::Payload

        schema do
          execute_at ActiveSupport::TimeWithZone, coerce: Core::TimeZoneCoercer
          command Message
        end
      end
    end

    module MetaData
      class V1
        extend Core::Payload

        schema do
          requestor_type Either(*Requestor::Kinds::ALL)
          requestor_id Either(String, nil)
        end
      end
    end

    V1 = Core::Schema.active(
      type: Core::COMMAND,
      data: Data::V1,
      metadata: MetaData::V1,
      aggregate: Aggregates::Task,
      message_type: MessageTypes::Infrastructure::SCHEDULE_TASK,
      version: 1
    )
  end
end
