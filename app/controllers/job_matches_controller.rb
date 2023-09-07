class JobMatchesController < ApplicationController
  def index
    render html: "Hello, World!"
  end

  def show
    jm = JobMatch::JobMatch.new(profile_id: params[:id])

    render json: {jobs: jm.jobs}
  end
end
