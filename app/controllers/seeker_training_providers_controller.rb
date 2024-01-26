class SeekerTrainingProvidersController < ApplicationController
  include Secured
  include Admin

  before_action :authorize
  before_action :admin_authorize

  def create
    seeker_id = params["seeker_id"]
    program_id = params["programId"]
    training_provider_id = params["trainingProviderId"]

    stp = SeekerTrainingProvider.create!(
      id: SecureRandom.uuid,
      program_id:,
      user_id: Seeker.find(seeker_id).user_id,
      training_provider_id:
    )

    render json: stp
  end

  def update
    seeker_id = params["seeker_id"]
    program_id = params["programId"]
    training_provider_id = params["trainingProviderId"]

    stp = SeekerTrainingProvider.find_by(
      user_id: Seeker.find(seeker_id).user_id
    )

    stp.program_id = program_id if program_id
    stp.training_provider_id = training_provider_id if training_provider_id

    stp.save!

    render json: stp
  end
end
