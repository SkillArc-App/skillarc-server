module Employers
  class ApplicationNotificationService < EventConsumer
    def self.handled_events
      [
        Events::ApplicantStatusUpdated::V3
      ].freeze
    end

    def self.handle_event(message, with_side_effects: true)
      case message.event_schema
      when Events::ApplicantStatusUpdated::V3
        handle_applicant_status_updated(message, with_side_effects:)
      end
    end

    def self.reset_for_replay
      Applicant.destroy_all
    end

    class << self
      private

      def handle_applicant_status_updated(message, with_side_effects: true)
        job = Job.find_by(job_id: message.data.job_id)
        applicant = Applicant.find_or_initialize_by(
          applicant_id: message.data.applicant_id,
          seeker_id: message.data.seeker_id,
          job:
        )

        applicant.update!(
          first_name: message.data.applicant_first_name,
          last_name: message.data.applicant_last_name,
          email: message.data.applicant_email,
          phone_number: message.data.applicant_phone_number,
          status: message.data.status
        )

        return unless with_side_effects
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
