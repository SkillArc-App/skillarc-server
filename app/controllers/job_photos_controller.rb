class JobPhotosController < ApplicationController
  include Secured
  include Admin

  before_action :authorize
  before_action :admin_authorize, only: %i[create destroy]
  before_action :set_job

  def create
    photo = Jobs::JobPhotosService.create(job, params[:job_photo][:photo_url])

    render json: photo
  end

  def destroy
    photo = job.job_photos.find(params[:id])

    Jobs::JobPhotosService.destroy(photo)

    render json: { success: true }
  end

  private

  attr_reader :job

  def set_job
    @job = Job.find(params[:job_id])
  end
end
