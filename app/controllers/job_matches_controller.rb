class JobMatchesController < ApplicationController
  include Secured

  before_action :authorize

  def index
    begin
      profile = current_user.profile

      jm = JobMatch::JobMatch.new(profile_id: profile.id)

      matched_jobs = jm.jobs

      render json: { matchedJobs: matched_jobs }
    rescue
      render json: { error: "Profile not found" }
    end
  end
end
