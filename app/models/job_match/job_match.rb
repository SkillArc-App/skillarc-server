module JobMatch
  class JobMatch
    attr_reader :profile

    def initialize(profile_id:)
      profile_profile = Profile.find(profile_id)

      @profile = { industry_interests: profile_profile.onboarding_session.industry_interests }
    end

    def jobs
      @jobs ||= Job.shown.with_everything.map do |job|
        job_tags = job.job_tags.map do |job_tag|
          {
            id: job_tag.id,
            tag: { name: job_tag.tag.name }
          }
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
          percent_match: match_score(job)
        }
      end.sort_by { |job| job[:percent_match] }.reverse
    end

    private

    def match_score(job)
      return 1 if profile[:industry_interests].include?(job[:industry]&.first)

      0
    end
  end
end
