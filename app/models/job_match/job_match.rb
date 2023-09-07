module JobMatch
  class JobMatch
    attr_reader :profile, :jobs

    def initialize(profile_id:)
      profile_profile = Profile.find(profile_id)

      @profile = { industry_interests: profile_profile.onboarding_session.industry_interests }
    end

    def jobs
      @jobs ||= Job.all.map do |job|
        { id: job.id, percent_match: match_score(job) }
      end.sort_by { |job| job[:percent_match] }.reverse
    end

    private

    def match_score(job)
      return 1 if profile[:industry_interests].include?(job[:industry]&.first)

      0
    end
  end
end