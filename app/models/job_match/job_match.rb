module JobMatch
  class JobMatch
    def initialize(profile_id:)
      @profile = Profile.find(profile_id)
    end

    def jobs
      save_events = Event.where(
        aggregate_id: profile.user.id,
        event_type: [Event::EventTypes::JOB_SAVED, Event::EventTypes::JOB_UNSAVED]
      ).group_by { |e| e.data[:job_id] }

      applicants = Applicant.where(profile_id: profile.id)

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
          careerPaths: job.career_paths.sort_by { |cp| cp[:order] },
          employerId: job.employer_id,
          employer: job.employer,
          employment_title: job.employment_title,
          industry: job.industry,
          benefitsDescription: job.benefits_description,
          responsibilitiesDescription: job.responsibilities_description,
          location: job.location,
          employmentType: job.employment_type,
          hideJob: job.hide_job,
          schedule: job.schedule,
          jobTag: job_tags,
          workDays: job.work_days,
          requirementsDescription: job.requirements_description,
          percent_match: match_score(job),
          saved: save_events[job.id]&.sort_by(&:occurred_at)&.last&.event_type == Event::EventTypes::JOB_SAVED,
          applied: application.present?,
          applicationStatus: application_status
        }
      end.sort_by { |job| job[:percent_match] }.reverse
    end

    private

    attr_reader :profile

    def match_score(job)
      industry_interests = profile.onboarding_session.industry_interests

      return 1 if industry_interests.include?(job[:industry]&.first)

      0
    end
  end
end
