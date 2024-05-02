class SeekerTrainingProvidersController < ApplicationController
  include Secured
  include Admin
  include MessageEmitter

  before_action :authorize
  before_action :admin_authorize

  def create
    Seeker.find(params["seeker_id"])

    with_message_service do
      message_service.create!(
        schema: Events::SeekerTrainingProviderCreated::V4,
        trace_id: request.request_id,
        seeker_id: params["seeker_id"],
        data: {
          id: SecureRandom.uuid,
          program_id: params["programId"],
          training_provider_id: params["trainingProviderId"],
          status: "Enrolled"
        }
      )
    end

    head :created
  end

  def update
    seeker = Seeker.find(params["seeker_id"])
    stp = SeekerTrainingProvider.find_by!(seeker:)

    with_message_service do
      message_service.create!(
        schema: Events::SeekerTrainingProviderCreated::V4,
        trace_id: request.request_id,
        seeker_id: params["seeker_id"],
        data: {
          id: stp.id,
          program_id: params["programId"],
          training_provider_id: params["trainingProviderId"],
          status: stp.status,
        }
      )
    end

    head :accepted
  end
end
