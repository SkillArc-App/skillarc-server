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

    def self.reset_for_replay
      Applicant.destroy_all
      Employer.destroy_all
      Job.destroy_all
      Recruiter.destroy_all
    end

    class << self
      private

      def handle_applicant_status_updated(message)
        job = Job.find_by(job_id: message.data.job_id)
        applicant = Applicant.find_or_initialize_by(
          applicant_id: message.data.applicant_id,
          seeker_id: message.data.seeker_id,
          job:
        )

        applicant.update!(
          status: message.data.status
        )
        # status: message.data.status

        # Contact::SmtpService.new.notify_employer_of_applicant(
      end

      def handle_employer_created(message)
        Employer.create!(
          employer_id: message.aggregate_id,
          name: message.data.name,
          location: message.data.location,
          bio: message.data.bio,
          logo_url: message.data.logo_url
        )
      end

      def handle_employer_invite_accepted(message)
        employer = Employer.find_by(employer_id: message.data.employer_id)

        Recruiter.create!(
          employer:,
          email: message.data.invite_email
        )
      end

      def handle_employer_updated(message)
        e = Employer.find_by(employer_id: message.aggregate_id)

        e.update!(
          **message.data.to_h
        )
      end

      def handle_job_created(message)
        employer = Employer.find_by(employer_id: message.data.employer_id)

        Job.create!(
          employer:,
          job_id: message.aggregate_id,
          employment_title: message.data.employment_title,
          benefits_description: message.data.benefits_description,
          responsibilities_description: message.data.responsibilities_description,
          location: message.data.location,
          employment_type: message.data.employment_type,
          hide_job: message.data.hide_job,
          schedule: message.data.schedule,
          work_days: message.data.work_days,
          requirements_description: message.data.requirements_description,
          industry: message.data.industry
        )
      end

      def handle_job_updated(message)
        job = Job.find_by(job_id: message.aggregate_id)

        job.update!(
          **message.data.to_h
        )
      end
    end
  end
end
