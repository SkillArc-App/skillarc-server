class EducationExperiencesController < ApplicationController
  include Secured

  before_action :authorize

  def create
    begin
      ee = EducationExperience.create!(
        **params.require(:education_experience).permit(
          :organization_name,
          :title,
          :graduation_date,
          :gpa,
          :activities
        ),
        id: SecureRandom.uuid,
        profile_id: current_user.profile.id
      )

      render json: ee
    rescue => e
      render json: { error: e.message }, status: :bad_request
    end
  end

  def update
    begin
      ee = EducationExperience.find(params[:id])

      ee.update!(**params.require(:education_experience).permit(
        :organization_name,
        :title,
        :graduation_date,
        :gpa,
        :activities
      ))

      render json: ee
    rescue => e
      render json: { error: e.message }, status: :bad_request
    end
  end

  def destroy
    begin
      ee = EducationExperience.find(params[:id])

      ee.destroy!

      render json: ee
    rescue => e
      render json: { error: e.message }, status: :bad_request
    end
  end
end
