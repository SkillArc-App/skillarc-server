class EducationExperiencesController < ApplicationController
  include Secured
  include ProfileAuth

  before_action :authorize
  before_action :set_profile
  before_action :profile_editor_authorize

  def create
    begin
      ee = EducationExperienceService.new(profile).create(
        **education_experience_params.to_h.symbolize_keys
      )

      render json: ee
    rescue => e
      render json: { error: e.message }, status: :bad_request
    end
  end

  def update
    begin
      ee = EducationExperienceService.new(profile).update(
        **education_experience_params.merge(id: params[:id])
      )

      render json: ee
    rescue => e
      render json: { error: e.message }, status: :bad_request
    end
  end

  def destroy
    begin
      ee = EducationExperienceService.new(profile).destroy(
        id: params[:id]
      )

      render json: ee
    rescue => e
      render json: { error: e.message }, status: :bad_request
    end
  end

  private

  attr_reader :profile

  def education_experience_params
    params.require(:education_experience).permit(
      :organization_name,
      :title,
      :graduation_date,
      :gpa,
      :activities
    ).to_h.symbolize_keys
  end

  def set_profile
    @profile = Profile.find(params[:profile_id])
  end
end
