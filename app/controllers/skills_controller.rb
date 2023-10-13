class SkillsController < ApplicationController
  include Secured

  before_action :authorize
  skip_before_action :verify_authenticity_token

  def create
    skill = ProfileSkill.create!(
      **params.require(:skill).permit(:name, :description, :master_skill_id, :type),
      id: SecureRandom.uuid,
      profile_id: current_user.profile.id
    )

    render json: skill
  end

  def update
    skill = ProfileSkill.find(params[:id])

    skill.update!(**params.require(:skill).permit(:name, :description, :master_skill_id, :type))

    render json: skill
  end

  def destroy
    skill = ProfileSkill.find(params[:id])

    skill.destroy!

    render json: skill
  end
end
