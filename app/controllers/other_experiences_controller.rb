class OtherExperiencesController < ApplicationController
  include Secured

  before_action :authorize

  def create
    other_experience = OtherExperience.create!(
      **params.require(:other_experience).permit(
        :organization_name,
        :position,
        :start_date,
        :end_date,
        :is_current,
        :description
      ),
      id: SecureRandom.uuid,
      profile: current_user.profile
    )

    render json: other_experience
  end

  def update
    other_experience = OtherExperience.find(params[:id])

    other_experience.update!(**params.require(:other_experience).permit(
      :organization_name,
      :position,
      :start_date,
      :end_date,
      :is_current,
      :description
    ))

    render json: other_experience
  end

  def destroy
    other_experience = OtherExperience.find(params[:id])

    other_experience.destroy!

    render json: other_experience
  end
end
