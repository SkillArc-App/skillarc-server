module JobMatch
  class JobMatch
    def initialize(user:)
      @user = user
    end

    def jobs
      save_events = Event
                    .where(
                      aggregate_id: user.id,
                      event_type: [Messages::Types::Seekers::JOB_SAVED, Messages::Types::Seekers::JOB_UNSAVED]
                    )
                    .map(&:message)
                    .group_by { |e| e.data[:job_id] }

      applicants = Applicant.where(seeker_id: user.seeker&.id)

      @jobs ||= Job.shown.with_everything.map do |job|
        job_tags = job.job_tags.map do |job_tag|
          {
            id: job_tag.id,
            tag: { name: job_tag.tag.name }
          }
        end

        application = applicants.find { |a| a.job_id == job.id }

        application_status =
          case application&.status&.status
          when ApplicantStatus::StatusTypes::NEW
            "Application Sent"
          when ApplicantStatus::StatusTypes::PENDING_INTRO
            "Introduction Sent"
          when ApplicantStatus::StatusTypes::INTERVIEWING
            "Interview in Progress"
          end

        {
          id: job.id,
          career_paths: job.career_paths.sort_by { |cp| cp[:order] },
          employer_id: job.employer_id,
          employer: job.employer,
          employment_title: job.employment_title,
          industry: job.industry,
          benefits_description: job.benefits_description,
          responsibilities_description: job.responsibilities_description,
          location: job.location,
          employment_type: job.employment_type,
          hide_job: job.hide_job,
          schedule: job.schedule,
          job_tag: job_tags,
          work_days: job.work_days,
          requirements_description: job.requirements_description,
          percent_match: match_score(job),
          saved: save_events[job.id]&.sort_by(&:occurred_at)&.last&.schema&.message_type == Messages::Types::Seekers::JOB_SAVED,
          applied: application.present?,
          elevator_pitch: application&.elevator_pitch,
          application_status:
        }
      end.sort_by { |job| job[:percent_match] }.reverse
    end

    private

    attr_reader :user

    def match_score(job)
      return 1 if user.seeker.blank?

      industry_interests = user.seeker.onboarding_session.industry_interests

      return 1 if industry_interests.include?(job[:industry]&.first)

      0
    end
  end
end
