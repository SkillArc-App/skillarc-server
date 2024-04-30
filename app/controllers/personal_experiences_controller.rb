class PersonalExperiencesController < ApplicationController
  include Secured
  include MessageEmitter

  before_action :authorize

  def create
    with_message_service do
      Seekers::SeekerReactor.new(message_service:).personal_experience_added(
        id: SecureRandom.uuid,
        trace_id: request.request_id,
        seeker_id: current_user.seeker.id,
        activity: personal_experience_params[:activity],
        start_date: personal_experience_params[:start_date],
        end_date: personal_experience_params[:end_date],
        description: personal_experience_params[:description]
      )
    end

    head :created
  end

  def update
    with_message_service do
      Seekers::SeekerReactor.new(message_service:).personal_experience_added(
        id: params[:id],
        trace_id: request.request_id,
        seeker_id: current_user.seeker.id,
        activity: personal_experience_params[:activity],
        start_date: personal_experience_params[:start_date],
        end_date: personal_experience_params[:end_date],
        description: personal_experience_params[:description]
      )
    end

    head :accepted
  end

  def destroy
    with_message_service do
      Seekers::SeekerReactor.new(message_service:).personal_experience_removed(
        seeker_id: current_user.seeker.id,
        trace_id: request.request_id,
        personal_experience_id: params[:id]
      )
    end

    head :accepted
  end

  private

  attr_reader :seeker

  def set_seeker
    @seeker = Seeker.find(params[:profile_id])
  end

  def personal_experience_params
    @personal_experience_params ||= params.require(:personal_experience).permit(
      :activity, :start_date, :end_date, :description
    ).to_h.symbolize_keys
  end
end
