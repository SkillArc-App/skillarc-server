class EducationExperiencesController < ApplicationController
  include Secured
  include SeekerAuth

  before_action :authorize
  before_action :set_seeker
  before_action :seeker_editor_authorize

  def create
    ee = EducationExperienceService.new(profile, seeker).create(
      **education_experience_params
    )

    render json: ee
  rescue StandardError => e
    render json: { error: e.message }, status: :bad_request
  end

  def update
    ee = EducationExperienceService.new(profile, seeker).update(
      **education_experience_params.merge(id: params[:id])
    )

    render json: ee
  rescue StandardError => e
    render json: { error: e.message }, status: :bad_request
  end

  def destroy
    ee = EducationExperienceService.new(profile, seeker).destroy(
      id: params[:id]
    )

    render json: ee
  rescue StandardError => e
    render json: { error: e.message }, status: :bad_request
  end

  private

  attr_reader :profile, :seeker

  def education_experience_params
    params.require(:education_experience).permit(
      :organization_name,
      :title,
      :graduation_date,
      :gpa,
      :activities
    ).to_h.symbolize_keys
  end

  def set_seeker
    @profile = Profile.find(params[:profile_id])
    @seeker = Seeker.find(params[:profile_id])
  end
end
