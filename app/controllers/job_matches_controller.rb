class JobMatchesController < ApplicationController
  # Check for bearer token first
  before_action :authenticate_user

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

  private

  def authenticate_user
    if request.authorization.nil?
      render json: {error: "Unauthorized"}, status: 401
    else
      token = request.authorization.split(" ").last

      if token != ENV["BEARER_TOKEN"]
        # render json: {error: "Unauthorized"}, status: 401
      end
    end
  end
end
