module Employers
  class ApplicationNotificationService < EventConsumer
    def self.handled_events
      [
        Events::ApplicantStatusUpdated::V1,
        Events::EmployerCreated::V1,
        Events::EmployerInviteAccepted::V1,
        Events::EmployerUpdated::V1,
        Events::JobCreated::V1,
        Events::JobUpdated::V1
      ].freeze
    end

    def self.handle_event(message, *_params)
      case message.event_schema
      when Events::ApplicantStatusUpdated::V1
        handle_applicant_status_updated(message)
      when Events::EmployerCreated::V1
        handle_employer_created(message)
      when Events::EmployerInviteAccepted::V1
        handle_employer_invite_accepted(message)
      when Events::EmployerUpdated::V1
        handle_employer_updated(message)
      when Events::JobCreated::V1
        handle_job_created(message)
      when Events::JobUpdated::V1
        handle_job_updated(message)
      end
    end

    def self.reset_for_replay; end

    class << self
      private

      def handle_applicant_status_updated(message); end

      def handle_employer_created(message); end

      def handle_employer_invite_accepted(message); end

      def handle_employer_updated(message); end

      def handle_job_created(message); end

      def handle_job_updated(message); end
    end
  end
end
