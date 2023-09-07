class JobMatchesController < ApplicationController
  # Check for bearer token first
  before_action :authenticate_user

  def index
    render html: "HELLO, WORLD!"
  end

  def show
    begin
      user_id = params[:id]
      profile = Profile.where(userId: user_id).first

      jm = JobMatch::JobMatch.new(profile_id: profile.id)

      matched_jobs = jm.jobs
      # matched_jobs = jm.jobs.map do |job|
      #   {
      #     id: job[:id],
      #     employerId: job[:employerId],
      #     benefitsDescription: job[:benefitsDescription],
      #     responsibilitiesDescription: job[:responsibilitiesDescription],
      #     employmentTitle: job[:employmentTitle],
      #     location: job[:location],
      #     employmentType: job[:employmentType],
      #     hideJob: job[:hideJob],
      #     schedule: job[:schedule],
      #     workDays: job[:workDays],
      #     requirementsDescription: job[:requirementsDescription],
      #     industry: job[:industry],
      #     percent_match: job[:percent_match]
      #   }
      # end

      render json: { matchedJobs: matched_jobs }
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
