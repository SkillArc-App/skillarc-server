class Programs::StudentsController < ApplicationController
  include Secured
  include TrainingProviderAuth
  include MessageEmitter

  before_action :authorize
  before_action :training_provider_authorize
  before_action :set_program, only: [:update]

  def update
    seeker_training_provider = Seeker.find(params[:id]).seeker_training_providers.find_by!(training_provider: training_provider_profile.training_provider, program:)

    with_message_service do
      Seekers::SeekerReactor.new(message_service:).add_seeker_training_provider(
        seeker_id: params[:id],
        trace_id: request.request_id,
        program_id: params[:program_id],
        training_provider_id: training_provider_profile.training_provider.id,
        status: params[:status],
        id: seeker_training_provider.id
      )
    end

    head :accepted
  end

  private

  attr_reader :program

  def set_program
    @program = training_provider_profile.training_provider.programs.find(params[:program_id])
  end
end
