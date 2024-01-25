class ProfilesController < ApplicationController
  include Secured
  include Admin
  include Cereal
  include SeekerAuth

  before_action :authorize, only: [:index, :update]
  before_action :admin_authorize, only: [:index, :update]
  before_action :set_seeker, only: [:show, :update]

  before_action :set_current_user, only: [:show]

  def index
    # Profile all with nested include of user and seeker_training_providers

    ps = Profile.includes(user: { seeker_training_providers: [:training_provider, :program] }).all.order(created_at: :desc).map do |p|
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
    render json: SeekerService.new(profile, seeker).get(seeker_editor: seeker_editor?)
  end

  def update
    SeekerService.new(profile, seeker).update(profile_params)

    render json: profile
  end

  private

  attr_reader :profile, :seeker

  def profile_params
    params.require(:profile).permit(
      :bio,
      :image,
      :met_career_coach,
      :status
    )
  end

  def set_seeker
    @profile = Profile.includes(profile_skills: :master_skill).find(params[:id])
    @seeker = Seeker.find_by(id: params[:id])
  end
end
