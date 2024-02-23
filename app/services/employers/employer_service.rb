module Employers
  class EmployerService < EventConsumer
    def self.handled_events_sync
      [
        Events::ApplicantStatusUpdated::V4
      ].freeze
    end

    def self.handled_events
      [
        Events::EmployerCreated::V1,
        Events::EmployerInviteAccepted::V1,
        Events::EmployerUpdated::V1,
        Events::JobCreated::V1,
        Events::JobOwnerAssigned::V1,
        Events::JobUpdated::V1
      ].freeze
    end

    def self.handle_event(message, *_params)
      case message.event_schema
      when Events::ApplicantStatusUpdated::V4
        handle_applicant_status_updated(message)
      when Events::EmployerCreated::V1
        handle_employer_created(message)
      when Events::EmployerInviteAccepted::V1
        handle_employer_invite_accepted(message)
      when Events::EmployerUpdated::V1
        handle_employer_updated(message)
      when Events::JobCreated::V1
        handle_job_created(message)
      when Events::JobOwnerAssigned::V1
        handle_job_owner_assigned(message)
      when Events::JobUpdated::V1
        handle_job_updated(message)
      end
    end

    def self.reset_for_replay
      Employer.destroy_all
      Job.destroy_all
      JobOwner.destroy_all
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
          first_name: message.data.applicant_first_name,
          last_name: message.data.applicant_last_name,
          email: message.data.applicant_email,
          phone_number: message.data.applicant_phone_number,
          status: message.data.status,
          status_as_of: message.occurred_at
        )
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

      def handle_job_owner_assigned(message)
        job = Job.find_by(job_id: message.data.job_id)
        recruiter = Recruiter.find_by(email: message.data.owner_email)

        JobOwner.create!(
          job:,
          recruiter:
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
