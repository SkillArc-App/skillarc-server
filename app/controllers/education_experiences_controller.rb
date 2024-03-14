class EducationExperiencesController < ApplicationController
  include Secured
  include SeekerAuth
  include EventEmitter

  before_action :authorize
  before_action :set_seeker
  before_action :seeker_editor_authorize

  def create
    with_event_service do
      ee = EducationExperienceService.new(seeker).create(
        **education_experience_params
      )

      render json: ee
    end
  rescue StandardError => e
    render json: { error: e.message }, status: :bad_request
  end

  def update
    with_event_service do
      ee = EducationExperienceService.new(seeker).update(
        **education_experience_params.merge(id: params[:id])
      )

      render json: ee
    end
  rescue StandardError => e
    render json: { error: e.message }, status: :bad_request
  end

  def destroy
    with_event_service do
      ee = EducationExperienceService.new(seeker).destroy(
        id: params[:id]
      )

      render json: ee
    end
  rescue StandardError => e
    render json: { error: e.message }, status: :bad_request
  end

  private

  attr_reader :seeker

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
    @seeker = Seeker.find(params[:profile_id])
  end
end
