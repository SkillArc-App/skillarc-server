class JobMatchesController < ApplicationController
  include Secured

  before_action :authorize

  def index
    begin
      profile = current_user.profile
      seeker = current_user.seeker

      jm = JobMatch::JobMatch.new(profile:, seeker:)

      matched_jobs = jm.jobs

      render json: { matchedJobs: matched_jobs }
    rescue
      render json: { error: "Profile not found" }
    end
  end
end
