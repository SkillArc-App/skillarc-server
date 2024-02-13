class SkillsController < ApplicationController
  include Secured

  before_action :authorize

  def create
    skill = ProfileSkill.create!(
      **params.require(:skill).permit(:name, :description, :master_skill_id, :type),
      id: SecureRandom.uuid,
      seeker: current_user.seeker
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
