class ProfilesController < ApplicationController
  include Secured
  include Admin
  include SeekerAuth
  include MessageEmitter

  before_action :authorize, only: %i[index]
  before_action :admin_authorize, only: %i[index]

  before_action :set_seeker, only: %i[show]
  before_action :set_current_user, only: [:show]

  def index
    seekers = Seeker.includes(:seeker_training_providers).order(created_at: :desc).map do |seeker|
      {
        id: seeker.id,
        first_name: seeker.user.first_name,
        last_name: seeker.user.last_name,
        email: seeker.user.email,
        training_provider: seeker.seeker_training_providers.map do |seeker_training_provider|
          {
            id: seeker_training_provider.training_provider.id,
            name: seeker_training_provider.training_provider.name
          }
        end
      }
    end

    render json: seekers
  end

  def show
    with_message_service do
      render json: SeekerService.new(seeker).get(user_id: current_user&.id, seeker_editor: seeker_editor?)
    end
  end

  private

  attr_reader :seeker

  def seeker_params
    params.require(:profile).permit(
      :bio,
      :image,
      :met_career_coach,
      :status
    )
  end

  def set_seeker
    @seeker = Seeker.includes(profile_skills: :master_skill).find(params[:id])
  end
end
