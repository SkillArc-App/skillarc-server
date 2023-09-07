module JobMatch
  class JobMatch
    attr_reader :profile, :jobs

    def initialize(profile_id:)
      profile_profile = Profile.find(profile_id)

      @profile = { industry_interests: profile_profile.onboarding_session.industry_interests }
    end

    def jobs
      @jobs ||= Job.all.map do |job|
        # binding.pry
        # employer = job.employer
        # binding.pry

        {
          id: job.id,
          employerId: job.employerId,
          employer: {
            id: job.employer.id,
            name: job.employer.name,
            location: job.employer.location,
            bio: job.employer.bio,
            logoUrl: job.employer.logoUrl,
          },
          employmentTitle: job.employmentTitle,
          industry: job.industry,
          benefitsDescription: job.benefitsDescription,
          responsibilitiesDescription: job.responsibilitiesDescription,
          location: job.location,
          employmentType: job.employmentType,
          hideJob: job.hideJob,
          schedule: job.schedule,
          workDays: job.workDays,
          requirementsDescription: job.requirementsDescription,
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