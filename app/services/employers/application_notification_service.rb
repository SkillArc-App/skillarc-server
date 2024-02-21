module Employers
  class ApplicationNotificationService < EventConsumer
    def self.handled_events
      [
        Events::ApplicantStatusUpdated::V4
      ].freeze
    end

    def self.handle_event(message)
      case message.event_schema
      when Events::ApplicantStatusUpdated::V4
        handle_applicant_status_updated(message)
      end
    end

    def self.reset_for_replay
      Applicant.destroy_all
    end

    class << self
      private

      def handle_applicant_status_updated(message)
        job = Job.find_by(job_id: message.data.job_id)

        message_applicant = message.data

        applicant = Struct.new(
          :applicant_id,
          :first_name,
          :last_name,
          :email,
          :phone_number,
          :seeker_id,
          :status,
          :status_as_of
        ).new

        applicant.applicant_id = message_applicant.applicant_id
        applicant.seeker_id = message_applicant.seeker_id
        applicant.first_name = message_applicant.applicant_first_name
        applicant.last_name = message_applicant.applicant_last_name
        applicant.email = message_applicant.applicant_email
        applicant.phone_number = message_applicant.applicant_phone_number
        applicant.status = message_applicant.status
        applicant.status_as_of = message.occurred_at

        return unless applicant.status == Applicant::StatusTypes::NEW

        job.owner_emails.each do |owner_email|
          Contact::SmtpService.new.notify_employer_of_applicant(
            job,
            owner_email,
            applicant
          )
        end
      end
    end
  end
end
