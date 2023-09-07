class JobMatchesController < ApplicationController
  def index
    render html: "HELLO, WORLD!"
  end

  def show
    begin
      jm = JobMatch::JobMatch.new(profile_id: params[:id])

      render json: {jobs: jm.jobs}
    rescue
      render json: {error: "Profile not found"}
    end
  end
end
