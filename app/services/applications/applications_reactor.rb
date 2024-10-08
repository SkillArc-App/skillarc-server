module Applications
  class ApplicationsReactor < MessageReactor
    def can_replay?
      true
    end

    on_message People::Events::PersonApplied::V1, :sync do |message|
      message_service.create_once_for_stream!(
        application_id: message.data.application_id,
        trace_id: message.trace_id,
        schema: Events::ApplicantStatusUpdated::V6,
        data: {
          applicant_first_name: message.data.seeker_first_name,
          applicant_last_name: message.data.seeker_last_name,
          applicant_email: message.data.seeker_email,
          applicant_phone_number: message.data.seeker_phone_number,
          seeker_id: message.stream.id,
          user_id: message.data.user_id,
          job_id: message.data.job_id,
          employer_name: message.data.employer_name,
          employment_title: message.data.employment_title,
          status: ApplicantStatus::StatusTypes::NEW,
          reasons: []
        },
        metadata: {
          user_id: message.data.user_id
        }
      )
    end

    on_message Events::ApplicantStatusUpdated::V6 do |message|
      data = message.data
      return unless data.status == ApplicantStatus::StatusTypes::NEW

      message_service.create_once_for_stream!(
        trace_id: message.trace_id,
        schema: Commands::SendSlackMessage::V2,
        message_id: message.deterministic_uuid,
        data: {
          channel: "#feed",
          text: "<#{ENV.fetch('FRONTEND_URL', nil)}/profiles/#{data.seeker_id}|#{data.applicant_email}> has applied to *#{data.employment_title}* at *#{data.employer_name}*"
        }
      )
    end

    on_message Events::ChatMessageSent::V2 do |message|
      applicant_status_updated = Projectors::Streams::GetFirst.project(
        stream: message.stream,
        schema: Events::ApplicantStatusUpdated::V6
      )

      return if applicant_status_updated.blank?

      data = applicant_status_updated.data

      text = if data.user_id == message.data.from_user_id
               "Applicant <#{ENV.fetch('FRONTEND_URL', nil)}/profiles/#{data.seeker_id}|#{data.applicant_email}> has *sent* a message to *#{data.employer_name}* for their applcation to *#{data.employment_title}*."
             else
               "Applicant <#{ENV.fetch('FRONTEND_URL', nil)}/profiles/#{data.seeker_id}|#{data.applicant_email}> has *received* a message from *#{data.employer_name}* for their applcation to *#{data.employment_title}*."
             end

      message_service.create_once_for_stream!(
        trace_id: message.trace_id,
        schema: Commands::SendSlackMessage::V2,
        message_id: message.deterministic_uuid,
        data: {
          channel: "#feed",
          text:
        }
      )
    end
  end
end
