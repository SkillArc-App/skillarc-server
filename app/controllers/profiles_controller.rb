class ProfilesController < ApplicationController
  include Secured
  include Admin
  include Cereal
  include SeekerAuth

  before_action :authorize, only: %i[index update]
  before_action :admin_authorize, only: %i[index update]
  before_action :set_seeker, only: %i[show update]

  before_action :set_current_user, only: [:show]

  def index
    # Profile all with nested include of user and seeker_training_providers

    ps = Seeker.includes(user: { seeker_training_providers: %i[training_provider program] }).order(created_at: :desc).map do |p|
      {
        **p.as_json,
        user: {
          **p.user.as_json,
          SeekerTrainingProvider: p.user.seeker_training_providers.map do |stp|
            {
              **stp.as_json,
              trainingProvider: stp.training_provider.as_json,
              program: stp.program.as_json
            }
          end.as_json
        }
      }
    end

    render json: ps
  end

  def show
    render json: SeekerService.new(seeker).get(seeker_editor: seeker_editor?)
  end

  def update
    SeekerService.new(seeker).update(seeker_params)

    render json: seeker
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
