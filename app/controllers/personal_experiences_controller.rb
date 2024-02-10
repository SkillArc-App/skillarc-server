class PersonalExperiencesController < ApplicationController
  include Secured

  before_action :authorize

  def create
    personal_experience = PersonalExperience.create!(
      **params.require(:personal_experience).permit(:activity, :start_date, :end_date, :description),
      id: SecureRandom.uuid,
      profile: current_user.profile,
      seeker: current_user.seeker
    )

    render json: personal_experience
  rescue StandardError => e
    render json: { error: e.message }, status: :bad_request
  end

  def update
    personal_experience = PersonalExperience.find(params[:id])

    personal_experience.update!(**params.require(:personal_experience).permit(:activity, :start_date, :end_date, :description))

    render json: personal_experience
  rescue StandardError => e
    render json: { error: e.message }, status: :bad_request
  end

  def destroy
    personal_experience = PersonalExperience.find(params[:id])

    personal_experience.destroy!

    render json: personal_experience
  rescue StandardError => e
    render json: { error: e.message }, status: :bad_request
  end
end
