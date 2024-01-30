class JobTagsController < ApplicationController
  include Secured
  include Admin

  before_action :authorize
  before_action :admin_authorize
  before_action :set_job

  def create
    tag = Tag.find_by!(name: params[:tag])

    render json: Jobs::JobTagService.create(job, tag)
  end

  def destroy
    tag = job.job_tags.find(params[:id])

    Jobs::JobTagService.destroy(tag)

    render json: { success: true }
  end

  private

  attr_reader :job

  def set_job
    @job = Job.find(params[:job_id])
  end
end
