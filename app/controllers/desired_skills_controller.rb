class DesiredSkillsController < ApplicationController
  include Secured
  include Admin

  before_action :authorize
  before_action :admin_authorize, only: %i[create destroy]
  before_action :set_job

  def create
    render json: Jobs::DesiredSkillService.create(job, params[:master_skill_id])
  end

  def destroy
    desired_skill = job.desired_skills.find(params[:id])

    Jobs::DesiredSkillService.destroy(desired_skill)

    render json: { success: true }
  end

  private

  attr_reader :job

  def set_job
    @job = Job.find(params[:job_id])
  end
end
