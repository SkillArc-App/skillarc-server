module Contact
  module CalDotCom
    class SchedulingReactor < MessageConsumer
      UnknownMeetingType = Class.new(StandardError)

      def reset_for_replay; end

      on_message Events::CalWebhookReceived::V1 do |message|
        return unless message.data.cal_trigger_event_type == Events::CalWebhookReceived::CalTriggerEventTypes::BOOKING_CREATED

        case message.data.payload[:type]
        when Events::CalWebhookReceived::KnownBookingTypes::CAREER_CONSULTATION
          handle_career_consolutation(message.trace_id, message.data.payload)
        else
          Sentry.capture_exception(UnknownMeetingType.new(message.data.payload[:type]))
        end
      end

      private

      def handle_career_consolutation(trace_id, payload)
        attendee = payload.dig(:attendees, 0)
        phone_number = payload[:location]

        lead_id = SecureRandom.uuid

        message_service.create!(
          trace_id:,
          context_id: lead_id,
          schema: Commands::AddLead::V1,
          data: {
            email: attendee[:email],
            lead_id:,
            phone_number:,
            first_name: attendee[:firstName],
            last_name: attendee[:lastName],
            lead_captured_by: "cal.com"
          }
        )

        return if payload[:additionalNotes].blank?

        message_service.create!(
          trace_id:,
          context_id: lead_id,
          schema: Commands::AddNote::V1,
          data: {
            originator: "cal.com",
            note: "From #{attendee[:firstName]} #{attendee[:lastName]} on the meeting invite: #{payload[:additionalNotes]}",
            note_id: SecureRandom.uuid
          }
        )
      end
    end
  end
end
