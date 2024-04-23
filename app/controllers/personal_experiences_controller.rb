class PersonalExperiencesController < ApplicationController
  include Secured
  include MessageEmitter

  before_action :authorize

  def create
    id = SecureRandom.uuid

    PersonalExperience.create!(
      **personal_experience_params,
      id:,
      seeker: current_user.seeker
    )

    with_message_service do
      Seekers::SeekerReactor.new(message_service:).add_personal_experience(
        **personal_experience_params,
        trace_id: request.request_id,
        seeker_id: current_user.seeker.id,
        id:
      )
    end

    head :created
  end

  def update
    personal_experience = PersonalExperience.find(params[:id])
    personal_experience.update!(**personal_experience_params)

    with_message_service do
      Seekers::SeekerReactor.new(message_service:).add_personal_experience(
        **personal_experience_params,
        trace_id: request.request_id,
        seeker_id: current_user.seeker.id,
        id: params[:id]
      )
    end

    head :accepted
  end

  def destroy
    personal_experience = PersonalExperience.find(params[:id])
    personal_experience.destroy!

    with_message_service do
      Seekers::SeekerReactor.new(message_service:).remove_personal_experience(
        seeker_id: current_user.seeker.id,
        trace_id: request.request_id,
        personal_experience_id: params[:id]
      )
    end

    head :accepted
  end

  private

  def personal_experience_params
    params.require(:personal_experience).permit(
      :activity, :start_date, :end_date, :description
    ).to_h.symbolize_keys
  end
end
