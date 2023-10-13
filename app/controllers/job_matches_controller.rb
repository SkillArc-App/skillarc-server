class JobMatchesController < ApplicationController
  include Secured

  before_action :authorize, only: [:index]

  def index
    render html: "HELLO, WORLD!"
  end

  def show
    begin
      user_id = params[:id]
      profile = Profile.where(user_id:).first

      jm = JobMatch::JobMatch.new(profile_id: profile.id)

      matched_jobs = jm.jobs

      render json: { matchedJobs: matched_jobs }
    rescue
      render json: { error: "Profile not found" }
    end
  end
end
