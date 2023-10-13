class DesiredSkillsController < ApplicationController
  include Secured
  include Admin

  before_action :authorize
  before_action :admin_authorize, only: [:create, :destroy]
  before_action :set_job

  def create
    job.desired_skills.create!(id: SecureRandom.uuid, master_skill_id: params[:master_skill_id])

    render json: { success: true }
  end

  def destroy
    desired_skill = job.desired_skills.find(params[:id])

    desired_skill.destroy!

    render json: { success: true }
  end

  private

  attr_reader :job

  def set_job
    @job = Job.find(params[:job_id])
  end
end
