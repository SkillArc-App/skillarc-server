class LearnedSkillsController < ApplicationController
  include Secured
  include Admin

  before_action :authorize
  before_action :admin_authorize, only: [:create, :destroy]
  before_action :set_job

  def create
    job.learned_skills.create!(id: SecureRandom.uuid, master_skill_id: params[:master_skill_id])

    render json: { success: true }
  end

  def destroy
    learned_skill = job.learned_skills.find(params[:id])

    learned_skill.destroy!

    render json: { success: true }
  end

  private

  attr_reader :job

  def set_job
    @job = Job.find(params[:job_id])
  end
end
