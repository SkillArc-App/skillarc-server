module Events
  module CoachReminderScheduled
    module Data
      class V1
        extend Messages::Payload

        schema do
          reminder_id Uuid
          context_id Either(String, nil)
          note String
          message_task_id Uuid
          reminder_at ActiveSupport::TimeWithZone, coerce: Messages::TimeZoneCoercer
        end
      end

      class V2
        extend Messages::Payload

        schema do
          reminder_id Uuid
          person_id Either(Uuid, nil)
          note String
          message_task_id Uuid
          reminder_at ActiveSupport::TimeWithZone, coerce: Messages::TimeZoneCoercer
        end
      end
    end

    V1 = Messages::Schema.inactive(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Coach,
      message_type: Messages::Types::Coaches::COACH_REMINDER_SCHEDULED,
      version: 1
    )
    V2 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V2,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Coach,
      message_type: Messages::Types::Coaches::COACH_REMINDER_SCHEDULED,
      version: 2
    )
  end
end
