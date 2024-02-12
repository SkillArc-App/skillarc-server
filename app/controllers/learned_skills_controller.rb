class LearnedSkillsController < ApplicationController
  include Secured
  include Admin

  before_action :authorize
  before_action :admin_authorize, only: %i[create destroy]
  before_action :set_job

  def create
    render json: Jobs::LearnedSkillService.create(job, params[:master_skill_id])
  end

  def destroy
    learned_skill = job.learned_skills.find(params[:id])

    Jobs::LearnedSkillService.destroy(learned_skill)

    render json: { success: true }
  end

  private

  attr_reader :job

  def set_job
    @job = Job.find(params[:job_id])
  end
end
