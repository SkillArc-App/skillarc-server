class PersonalExperiencesController < ApplicationController
  include Secured

  before_action :authorize

  def create
    begin
      personal_experience = PersonalExperience.create!(
        **params.require(:personal_experience).permit(:activity, :start_date, :end_date, :description),
        id: SecureRandom.uuid,
        profile_id: current_user.profile.id
      )

      render json: personal_experience
    rescue => e
      render json: { error: e.message }, status: 400
    end
  end

  def update
    begin
      personal_experience = PersonalExperience.find(params[:id])

      personal_experience.update!(**params.require(:personal_experience).permit(:activity, :start_date, :end_date, :description))

      render json: personal_experience
    rescue => e
      render json: { error: e.message }, status: 400
    end
  end

  def destroy
    begin
      personal_experience = PersonalExperience.find(params[:id])

      personal_experience.destroy!

      render json: personal_experience
    rescue => e
      render json: { error: e.message }, status: 400
    end
  end
end
