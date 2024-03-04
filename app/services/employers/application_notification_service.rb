module Employers
  class ApplicationNotificationService < EventConsumer
    def handled_events
      [
        Events::ApplicantStatusUpdated::V5
      ].freeze
    end

    def handle_message(message)
      case message.schema
      when Events::ApplicantStatusUpdated::V5
        handle_applicant_status_updated(message)
      end
    end

    def reset_for_replay
      Applicant.destroy_all
    end

    private

    def handle_applicant_status_updated(message)
      return unless message.data.status == Applicant::StatusTypes::NEW

      job = Job.find_by!(job_id: message.data.job_id)
      certified_by = Seeker.find_by(seeker_id: message.data.seeker_id)&.certified_by

      data = message.data

      job.owner_emails.each do |owner_email|
        CommandService.create!(
          command_schema: Commands::NotifyEmployerOfApplicant::V1,
          applicant_id: data.applicant_id,
          trace_id: message.trace_id,
          data: Commands::NotifyEmployerOfApplicant::Data::V1.new(
            employment_title: data.employment_title,
            recepent_email: owner_email,
            certified_by:,
            applicant_first_name: data.applicant_first_name,
            applicant_last_name: data.applicant_last_name,
            applicant_seeker_id: data.seeker_id,
            applicant_email: data.applicant_email,
            applicant_phone_number: data.applicant_phone_number
          )
        )
      end
    end
  end
end
