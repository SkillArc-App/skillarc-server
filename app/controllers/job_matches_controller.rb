class JobMatchesController < ApplicationController
  include Secured

  before_action :authorize

  def index
    jm = JobMatch::JobMatch.new(user: current_user)

    matched_jobs = jm.jobs

    render json: { matchedJobs: matched_jobs }
  end
end
