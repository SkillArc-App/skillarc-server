module Events
  module CoachReminderCompleted
    module Data
      class V1
        extend Messages::Payload

        schema do
          reminder_id Uuid
        end
      end
    end

    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      stream: Streams::Coach,
      message_type: Messages::Types::Coaches::COACH_REMINDER_COMPLETED,
      version: 1
    )
  end
end
