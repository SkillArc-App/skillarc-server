# I think this is an aggregate

# module Match
#   class Profile
#     attr_reader :industry_interests

#     def initialize(industry_interests:)
#       @industry_interests = industry_interests
#     end
#   end

#   class Job
#     attr_reader :industry

#     def initialize(industry: "")
#       @industry = industry
#     end
#   end
# end

# class JobMatch
#   def initialize(profile:, job:)
#     @profile = profile
#     @job = job
#   end

#   def match_score
#     return 1 if profile.industry_interests.include?(job.industry)

#     0
#   end

#   private

#   attr_reader :profile, :job
# end
