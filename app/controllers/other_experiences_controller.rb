class OtherExperiencesController < ApplicationController
  include Secured
  include SeekerAuth
  include MessageEmitter

  before_action :authorize
  before_action :set_seeker
  before_action :seeker_editor_authorize

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
      seeker:
    )

    with_message_service do
      Seekers::SeekerReactor.new(message_service:).add_experience(
        id: other_experience.id,
        trace_id: request.request_id,
        organization_name: other_experience.organization_name,
        position: other_experience.position,
        start_date: other_experience.start_date,
        end_date: other_experience.end_date,
        is_current: other_experience.is_current,
        description: other_experience.description,
        seeker_id: seeker.id
      )
    end

    head :created
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

    with_message_service do
      Seekers::SeekerReactor.new(message_service:).add_experience(
        id: params[:id],
        trace_id: request.request_id,
        organization_name: other_experience.organization_name,
        position: other_experience.position,
        start_date: other_experience.start_date,
        end_date: other_experience.end_date,
        is_current: other_experience.is_current,
        description: other_experience.description,
        seeker_id: seeker.id
      )
    end

    head :accepted
  end

  def destroy
    other_experience = OtherExperience.find(params[:id])

    other_experience.destroy!

    with_message_service do
      Seekers::SeekerReactor.new(message_service:).remove_experience(
        trace_id: request.request_id,
        experience_id: params[:id],
        seeker_id: seeker.id
      )
    end

    head :accepted
  end

  private

  attr_reader :seeker

  def set_seeker
    @seeker = Seeker.find(params[:profile_id])
  end
end
