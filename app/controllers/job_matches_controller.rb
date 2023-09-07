class JobMatchesController < ApplicationController
  def index
  end

  def show
    jm = JobMatch::JobMatch.new(profile_id: params[:id])

    render json: {jobs: jm.jobs}
  end
end
