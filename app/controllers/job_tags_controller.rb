class JobTagsController < ApplicationController
  include Secured
  include Admin

  before_action :authorize
  before_action :admin_authorize
  before_action :set_job

  def create
    job_tag = job.job_tags.find_or_initialize_by(tag_id: params[:tag_id]) do |jt|
      jt.id = SecureRandom.uuid
      jt.save!
    end

    render json: job_tag
  end

  def destroy
    tag = job.job_tags.find(params[:id])

    tag.destroy!

    render json: { success: true }
  end

  private

  attr_reader :job

  def set_job
    @job = Job.find(params[:job_id])
  end
end
