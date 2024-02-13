class Programs::StudentsController < ApplicationController
  include Secured
  include TrainingProviderAuth

  before_action :authorize
  before_action :training_provider_authorize
  before_action :set_program, only: [:update]

  def update
    seeker_training_provider = Seeker.find(params[:id]).user.seeker_training_providers.find_by!(training_provider: training_provider_profile.training_provider, program:)
    new_status = SeekerTrainingProviderProgramStatus.create!(
      id: SecureRandom.uuid,
      seeker_training_provider:,
      status: params[:status]
    )

    render json: new_status
  end

  private

  attr_reader :program

  def set_program
    @program = training_provider_profile.training_provider.programs.find(params[:program_id])
  end
end
