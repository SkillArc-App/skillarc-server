module Contact
  module CalDotCom
    class SchedulingReactor < MessageConsumer
      UnknownMeetingType = Class.new(StandardError)

      def reset_for_replay; end

      on_message Events::CalWebhookReceived::V1 do |message|
        return unless message.data.cal_trigger_event_type == Events::CalWebhookReceived::CalTriggerEventTypes::BOOKING_CREATED

        case message.data.payload["type"]
        when Events::CalWebhookReceived::KnownBookingTypes::CAREER_CONSULTATION
          handle_career_consolutation(message.trace_id, message.data.payload)
        else
          Sentry.capture_exception(UnknownMeetingType.new(message.data.payload["type"]))
        end
      end

      private

      def handle_career_consolutation(trace_id, payload)
        attendee = payload.dig("attendees", 0)
        coach_email = payload.dig("organizer", "email")
        phone_number = payload["location"]

        lead_id = SecureRandom.uuid

        add_lead_data = Commands::AddLead::Data::V1.new(
          email: attendee["email"],
          lead_id:,
          phone_number:,
          first_name: attendee["firstName"],
          last_name: attendee["lastName"],
          lead_captured_by: "cal.com"
        )

        assign_coach_data = Commands::AssignCoach::Data::V1.new(
          coach_email:
        )

        command_service.create!(
          trace_id:,
          context_id: lead_id,
          command_schema: Commands::AddLead::V1,
          data: add_lead_data
        )

        command_service.create!(
          trace_id:,
          context_id: lead_id,
          command_schema: Commands::AssignCoach::V1,
          data: assign_coach_data
        )

        return if payload['additionalNotes'].blank?

        add_note_data = Commands::AddNote::Data::V1.new(
          originator: "cal.com",
          note: "From #{attendee['firstName']} #{attendee['lastName']} on the meeting invite: #{payload['additionalNotes']}",
          note_id: SecureRandom.uuid
        )

        command_service.create!(
          trace_id:,
          context_id: lead_id,
          command_schema: Commands::AddNote::V1,
          data: add_note_data
        )
      end
    end
  end
end
